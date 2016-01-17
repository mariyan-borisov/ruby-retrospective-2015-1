def grow(snake, direction)
  grown_snake = snake.dup
  grown_snake << snake.last.map.with_index { |e, i| e + direction[i] }
end

def move(snake, direction)
  moved_snake = grow(snake, direction)
  moved_snake.delete_at 0
  moved_snake
end

def new_food(food, snake, dimensions)
  x_axis_indexes = (0..dimensions[:width] - 1).to_a
  y_axis_indexes = (0..dimensions[:height] - 1).to_a
  free_blocks = x_axis_indexes.product(y_axis_indexes) - food - snake
  free_blocks.sample
end

def obstacle_ahead?(snake, direction, dimensions)
  moved_snake = move(snake, direction)
  head_position = moved_snake.last
  head_position.first < 0 or head_position.first >= dimensions[:width] \
    or head_position.last < 0 or head_position.last >= dimensions[:height] \
    or moved_snake.index(head_position) != moved_snake.size - 1
end

def danger?(snake, direction, dimensions)
  if obstacle_ahead?(snake, direction, dimensions)
    true
  else
    moved_snake = move(snake, direction)
    obstacle_ahead?(moved_snake, direction, dimensions)
  end
end
