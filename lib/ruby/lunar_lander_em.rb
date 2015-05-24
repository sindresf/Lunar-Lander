class Lunar_lander_em
  attr_accessor :game
  attr_reader :id
  def initialize(game)
    @id               = java.util.UUID.randomUUID().to_s
    @game             = game
    @ids_to_tags      = Hash.new
    @tags_to_ids      = Hash.new
    @component_stores = Hash.new
    @mutex = Mutex.new
  end

  def all_entities
    return @ids_to_tags.keys
  end

  def get_all_entities_tagged_with(tag)
    @tags_to_ids[tag]
  end

  def create_basic_entity
    uuid = java.util.UUID.randomUUID().to_s
    @ids_to_tags[uuid] = '-' # means 'untagged', consequently not going into tags_to_ids
    return uuid
  end

  def get_tag(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?
    @ids_to_tags[entity]
  end

  def create_tagged_entity(readable_tag)
    raise ArgumentError, "Must specify tag" if readable_tag.nil?
    raise ArgumentError, "Tag '-' is reserved and cannot be used" if readable_tag == '-'

    @mutex.synchronize do
      uuid = create_basic_entity
      @ids_to_tags[uuid] = readable_tag
      if @tags_to_ids.has_key? readable_tag
        @tags_to_ids[readable_tag] << uuid
      else
        @tags_to_ids[readable_tag] = [uuid]
      end

      return uuid
    end
  end

  def add_component(entity, component) #uuid so as to not be confused with 'tag'
    raise ArgumentError, "UUID and component must be specified" if entity.nil? || component.nil?

    # Get the store for this component class.
    # IF it doesn't exist, make it.
    store = @component_stores[component.class]
    if store.nil?
      store = Hash.new
      @component_stores[component.class] = store
    end

    if store.has_key? entity
      store[entity] << component unless store[entity].include component
    else
      store[entity] = [component]
    end
  end

  def get_component_of_type(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    # return nil unless has_component_of_type?(entity, component.class)
    store = @component_stores[component_class]
    return nil if store.nil?

    components = store[entity]
    return nil if components.nil? || components.empty?

    if components.size != 1
      puts "Warning: you probably expected #{entity} to have just one #{component_class.to_s} but it had #{components.size}...returning first."
    end

    return components.first
  end

  def get_components_of_type(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    # return nil unless has_component_of_type?(entity, component.class)
    store = @component_stores[component_class]
    return nil if store.nil?

    components = store[entity]
    return nil if components.nil? || components.empty?

    return components
  end

  def get_all_components_of_type(component_sym)
    Set.new(@component_stores[component_sym].values).flatten
  end

  def get_all_components(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?

    @mutex.synchronize do
      components = []
      @component_stores.values.each do |store|
        if store[entity]
          components += store[entity]
        end
      end
      components
    end
  end

  def get_all_entities_with_component_of_type(component_class)
    raise ArgumentError, "Component class must be specified" if component_class.nil?

    store = @component_stores[component_class]
    if store.nil?
      return []
    else
      return store.keys
    end
  end

  def get_all_entities_with_components_of_type(component_classes)
    raise ArgumentError, "Component classes must be specified" if component_classes.nil?

    entities = all_entities
    component_classes.each do |klass|
      entities = entities & get_all_entities_with_component_of_type(klass)
    end
    return entities
  end

  def kill_entity(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?

    @component_stores.each_value do |store|
      store.delete(entity)
    end
    @tags_to_ids.each_key do |tag|
      if @tags_to_ids[tag].include? entity
        @tags_to_ids[tag].delete entity
      end
    end

    if @ids_to_tags.delete(entity)==nil
      return false
    else
      return true
    end
  end

  def dump_details
    output = to_s
    all_entities.each do |e|
      output << "\n #{e} (#{@ids_to_tags[e]})"
      comps = get_all_components(e)
      comps.each do |c|
        output << "\n   #{c.to_s}"
      end
    end

    output
  end

  def has_component?(entity, component)
    raise ArguentError, "UUID and component must be specified" if entity.nil? || component.nil?

    store = @component_stores[component.class]
    if store.nil?
      return false # NOBODY has this component type
    else
      return store.has_key?(entity) && store[entity].inlcude?(component)
    end
  end

  def has_component_of_type?(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    store = @component_stores[component_class]
    if store.nil?
      return false  #NOBODY has this component type
    else
      store.has_key?(entity) && store[entity].size > 0
    end
  end

  def marshal_dump
    [@id, @ids_to_tags, @tags_to_ids, @component_stores]
  end

  def marshal_load(array)
    @id, @ids_to_tags, @tags_to_ids, @component_stores = array
    @mutex = Mutex.new
  end

  def to_s
    "EntityManager {#{id}: #{all_entities.size} managed entities}"
  end
end