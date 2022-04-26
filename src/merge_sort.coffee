merge = (left, right, comparison) ->
  result = new Array()
  while (left.length > 0) and (right.length > 0)
    if comparison(left[0], right[0]) <= 0
      result.push left.shift()
    else
      result.push right.shift()
  result.push left.shift() while left.length > 0
  result.push right.shift() while right.length > 0
  result
merge_sort = (array, comparison) ->
  return array if array.length < 2
  middle = Math.ceil(array.length / 2)
  merge merge_sort(array.slice(0, middle), comparison), merge_sort(array.slice(middle), comparison), comparison
exports.merge_sort = merge_sort
