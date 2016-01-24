def grow(snake, direction)
  grown_snake = snake.dup
  grown_snake << snake.last.map.with_index { |e, i| e + direction[i] }
end

def move(snake, direction)
  moved_snake = grow(snake, direction)
  moved_snake.shift
  moved_snake
end

def new_food(food, snake, dimensions)
  x_axis_indexes = (0...dimensions[:width]).to_a
  y_axis_indexes = (0...dimensions[:height]).to_a
  free_blocks = x_axis_indexes.product(y_axis_indexes) - food - snake
  free_blocks.sample
end

def obstacle_ahead?(snake, direction, dimensions)
  moved_snake = move(snake, direction)
  head_position = moved_snake.last
  head_position[0] < 0 or head_position[0] >= dimensions[:width] or
    head_position[1] < 0 or head_position[1] >= dimensions[:height] or
    snake.include?(head_position)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
