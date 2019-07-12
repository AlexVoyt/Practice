{IsLeapYear in FirstFilecheck, ReadInput uses it}
program main;
uses GlobalTypes, FirstFileCheck, SecondFileCheck, ReadInput;
var
   staff, catalog, output_file : text;
   table_of_person : TableOfPerson;
   table_of_qualification : TableOfQualification;
   output_table : TableOfPerson;
   input_date : Date;
   fatal_error : boolean;
begin

   assign(staff, 'Staff.txt');
   assign(catalog, 'Catalog.txt');
   assign(output_file, 'Output.txt');
   reset(staff);
   reset(catalog);
   rewrite(output_file);

   ReadInputDate(input_date);
   writeln();
   writeln(input_date.year);
   writeln(input_date.month);
   writeln(input_date.day);


   if SeekEOF(Staff) then
   begin
      writeln('File Staff is empty');
   end;

end.
