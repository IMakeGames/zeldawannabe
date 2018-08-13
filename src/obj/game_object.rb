# Primary Game Object.
# It serves as the core of other objects. Defines association with a HitBox object and a Sprite object.
#
# Class Attributes:
# * z_rendering: Defines Rendering order in z coordinate.
# * hb: Instanciates the associated HitBox
# * id: Object Id
# * sprite: associated Sprite Object

class GameObject
  attr_accessor :z_rendering, :hb, :id, :vect_v, :vect_acc, :vect_angle, :max_v
  attr_reader :sprite, :state

  # Initializer Method.
  # params:
  # - x, y: Defines initial position.
  # - w, h: Defines height and width of hitbox.
  #
  # All parameters are used to create the associated hitbox.
  # An empty sprite is initialized.
  def initialize(x, y, w, h)
    @sprite = nil
    @vect_v = 0
    @vect_acc = 0
    @vect_angle = 180
    @max_v = 0
    @hb = HitBox.new(x, y, w, h)
  end

  # Method that changes the position of the hitbox..
  # params:
  # - x, y: Defines new position.
  def place(x, y)
    @hb.place(x, y)
  end

  # Method that calls the draw method of the sprite.
  # * If draw_hb variable is true, then calls draw method of hitbox.
  # * Calls linear animation method of sprite
  # * Does not call method if sprite doesn't exists
  def draw
    if $WINDOW.draw_hb
      @hb.draw
    end
    @sprite.animate_linear(@hb.x, @hb.y, @hb.y+@hb.h) unless @sprite == nil
  end

  # Changes the state. Custom method is used in order to change sprite as well.
  # params:
  # - id: The id of the new state.
  def change_state(id)
    @state = id
    @sprite.change_state(id) unless @sprite == nil
  end

  #The next few methods return booleans according to the state the object is in.
  #===================================== START: STATE METHODS ===============================

  #TODO: Must check whether it is convenient to implement this method.
  def impacted
  end

  #Main update method. All classes that inherit from GameObject must implement it.
  def update
    raise "THIS METHOD MUST BE IMPLEMENTED"
  end

  def idle?
    return @state == GameStates::States::IDLE
  end

  def walking?
    return @state == GameStates::States::WALKING
  end

  def attacking?
    return @state == GameStates::States::ATTACKING
  end

  def recoiling?
    return @state == GameStates::States::RECOILING
  end

  def dying?
    return @state == GameStates::States::DYING
  end

  def blocking?
    return @state == GameStates::States::BLOCKING
  end
  #===================================== END: STATE METHODS ===============================

  # Method destroys current object. To do this, the object must be removed from list of existing objects.
  def die
    $WINDOW.current_map.remove_from_game(self)
  end
end