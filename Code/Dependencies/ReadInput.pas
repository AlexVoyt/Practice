unit ReadInput;
uses GlobalTypes, FirstFileCheck;

Interface
   procedure ReadInput(var date : Date);

Implementation

   procedure ReadInput(var date : Date);
   begin
      ReadYear(date);
      ReadMonth(date);
      ReadDay(date);
   end;

   procedure ReadYear(var date : Date);
   begin
      writeln('Enter the year [2016..2017]');
      repeat
      begin
         readln(date.year);
         if (date.year > 2017) or (date.year < 2016) then
            writeln('Year must be in range [2016..2017]');
      end;
      until (date.year <= 2017) and (date.year >= 2016);
   end;

end.
