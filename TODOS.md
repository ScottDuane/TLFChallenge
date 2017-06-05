Improvements to be made:

-[x] The views don't render the errors!  
-[ ] Refactor with partials!
-[x] Flash or flash.now?
-[x] Min of months in between should be 1, not 0
-[ ] Bug: the get_first_occurrence method was broken. It should check the day of the week of the *start_date*, not today.
-[ ] get_actual_occurrence was not resetting the month correctly when the year walked backward by 1
-[ ] get_actual_occurrence should set the date before the while loop, just in case the while loop doesn't get hit
-[ ] get_past_occurrences should be refactored so that it utilizes the logic in get_first_occurrence
-[ ] get_first_occurrence needs to check if its day of the month falls at the end of a month 
