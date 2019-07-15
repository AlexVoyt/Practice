{IsLeapYear in FirstFilecheck, ReadInput uses it}
program main;
uses GlobalTypes, ReadInput, FirstFileCheck, SecondFileCheck, CorrectnessChecking;
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

   {ReadInputDate(input_date);}
   writeln();

   if SeekEOF(catalog) then
   begin
      writeln('File Catalog is empty');
      fatal_error := true;
   end else
      ParseCatalog (catalog, table_of_qualification, fatal_error);

   if SeekEOF(staff) then
   begin
      writeln('File Staff is empty');
      fatal_error := true;
   end;
   if fatal_error = false then
      ParseStaff (staff, table_of_person, fatal_error);


end.
