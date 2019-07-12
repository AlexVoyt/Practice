unit ReadInput;

Interface
   uses GlobalTypes, FirstFileCheck;

   procedure ReadInputDate(var date : Date);

Implementation

   procedure ReadYear(var date : Date);
   begin
      writeln('Enter the year [2016..2017]');
      repeat
      begin
         readln(date.year);
         if (date.year > 2017) or (date.year < 2016) then
            writeln('Year must be in range [2016..2017], please, repeat input');
      end;
      until (date.year <= 2017) and (date.year >= 2016);
   end;

   procedure ReadMonth(var date : Date);
   begin
      writeln('Enter the month [1..12]');
      repeat
      begin
         readln(date.month);
         if (date.month > 12) or (date.month < 1) then
            writeln('Month must be in range [1.12], please, repeat input');
      end;
      until (date.month <= 12) and (date.month >= 1);
   end;

   procedure ReadDay(var date : Date);
   begin
      case date.month of
      1,3,5,7,8,10,12:
      begin
         writeln('Enter the day [1..31]');
         repeat
            read(date.day);
            if (date.day < 1) or (date.day > 31) then
               writeln('Day must be in range [1..31], please, repeat input')
         until (date.day >= 1) and (date.day <= 31);
      end;
      4,6,9,11:
      begin
         writeln('Enter the day [1..30]');
         repeat
            read(date.day);
            if (date.day < 1) or (date.day > 30) then
               writeln('Day must be in range [1..30], please, repeat input');
         until (date.day >= 1) and (date.day <= 30);
      end;
      2:
         if IsLeapYear(date.year) then
         begin
            writeln('Enter the day [1..29]');
            repeat
               read(date.day);
               if (date.day < 1) or (date.day > 29) then
                  writeln('Day must be in range [1..29], please, repeat input');
            until (date.day >= 1) and (date.day <= 29);
         end
         else
         begin
            writeln('Enter the day [1..28]');
            repeat
               read(date.day);
               if (date.day < 1) or (date.day > 28) then
                  writeln('Day must be in range [1..28], please, repeat input');
            until (date.day >= 1) and (date.day <= 28);
         end;
      end;
   end;

   procedure ReadInputDate(var date : Date);
   begin
      ReadYear(date);
      ReadMonth(date);
      ReadDay(date);
   end;

end.
