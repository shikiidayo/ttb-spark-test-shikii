list_a = [1, 2, 3, 5, 6, 8, 9]
list_b = [3, 2, 1, 5, 6, 0]

def find_duplicates_with_last_list(list_name_original,list_name_new):
    return [item for item in list_name_new  if item in list_name_original]

answer_list = find_duplicates_with_last_list(list_a, list_b)

print("New list:", answer_list)

sorted_answer_list = sorted(answer_list)

print ("Sorted list:", sorted_answer_list)