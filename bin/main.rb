$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/ruby/', __FILE__)

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'Lunar-Lander/' : ''

require 'java'
require "gdx-backend-lwjgl-natives.jar"
require "gdx-backend-lwjgl.jar"
require "gdx-natives.jar"
require "gdx.jar"

java_import com.badlogic.gdx.ApplicationListener
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input
java_import com.badlogic.gdx.graphics.GL10
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.OrthographicCamera
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.graphics.g2d.BitmapFont
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

require 'LunarLanderGame'
require 'logger'

$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG
$logger.info 'Uses The Ruby Entity-Component Framework, Copyright 2012 Prylis Inc.'
$logger.info 'See https://github.com/cpowell/ruby-entity-component-framework'

cfg = LwjglApplicationConfiguration.new
cfg.title = "LunarLander"
cfg.useGL20 = true
cfg.width = 900
cfg.height = 600

game = LunarLanderGame.new

LwjglApplication.new(game, cfg)

# Prevent application from exiting while running as a jar
while game.is_running
  sleep(1)
end

