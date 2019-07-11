unit FirstFileCheck;

Interface
   uses GlobalTypes;

   function IsLeapYear(year : word) : boolean;

Implementation

   function IsLeapYear(year : word) : boolean;
   begin
      IsLeapYear:= false;
      if (year mod 400 = 0) then
         IsLeapYear:= true;
   end;
end.
