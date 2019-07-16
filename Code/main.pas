program main;
uses GlobalTypes, ReadInput, FirstFileCheck, SecondFileCheck,
     Selection, CorrectnessChecking;
var
   staff, catalog, output_file : text;
   table_of_person : TableOfPerson;
   table_of_qualification : TableOfQualification;
   output_table : InfoTable;
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

   if SeekEOF(catalog) then
   begin
      writeln('File Catalog is empty');
      fatal_error := true;
   end else
   begin
      writeln('==========Checking file Catalog==========');
      ParseCatalog (catalog, table_of_qualification, fatal_error);
   end;


   if SeekEOF(staff) then
   begin
      writeln('File Staff is empty');
      fatal_error := true;
   end;
   if fatal_error = false then
   begin
      writeln('==========Checking file Staff==========');
      ParseStaff (staff, table_of_person, fatal_error);
   end
   else
      writeln('=== Fatal error occured during parsing Catalog, terminating ===');

   if fatal_error = false then
   begin
      writeln('================================');
      SelectStaff(input_date,
                  output_file,
                  table_of_person,
                  table_of_qualification,
                  output_table);
      if output_table[MAX_CORRECT_LINES - 1].name = '' then
         writeln('All staff has passed certification');
   end;

   {
   for i := 0 to MAX_CORRECT_LINES - 1 do
   begin
      if table_of_person[i].name = '' then continue;
      writeln('===========================');
      writeln('Index - ', i);
      writeln('Name - ', table_of_person[i].name);
      writeln('Gender - ', table_of_person[i].gender);
      writeln('Profession - ', table_of_person[i].profession);
      writeln('Birth date - ', table_of_person[i].birth.day, '/', table_of_person[i].birth.month, '/', table_of_person[i].birth.year);
      writeln('Certification date - ', table_of_person[i].certificate.day, '/', table_of_person[i].certificate.month, '/', table_of_person[i].certificate.year);
   end;

   for i := 0 to MAX_CORRECT_LINES - 1 do
   begin
      if table_of_qualification[i].period = 0 then continue;
      writeln('===========================');
      writeln('Index - ', i);
      writeln('Period - ', table_of_qualification[i].period);
      writeln('Profession - ', table_of_qualification[i].profession);
   end;
   }
   {
   for i := 0 to MAX_CORRECT_LINES - 1 do
   begin
      if output_table[i].name = '' then continue;
      writeln('===========================');
      writeln('Index - ', i);
      writeln('Name - ', output_table[i].name);
      writeln('Profession - ', output_table[i].profession);
      writeln('Certification date - ', output_table[i].certificate.day, '/', output_table[i].certificate.month, '/', output_table[i].certificate.year);
   end;
   }

   close(staff);
   close(catalog);
   close(output_file);
end.
