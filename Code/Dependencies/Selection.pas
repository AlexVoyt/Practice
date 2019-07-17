unit Selection;

Interface
   uses GlobalTypes, CorrectnessChecking;


   procedure SelectStaff(input_date : Date;
                         var f : text;
                         var array_of_person : TableOfPerson;
                         var array_of_qualification : TableOfQualification;
                         var output_table : InfoTable);

Implementation

   procedure SelectStaff(input_date : Date;
                         var f : text;
                         var array_of_person : TableOfPerson;
                         var array_of_qualification : TableOfQualification;
                         var output_table : InfoTable);
   var
      is_period_exist : boolean;
      i, j, non_passed  : byte;
   begin
      i := 0;
      j := 0;
      non_passed := 0;
      while array_of_person[i].name <> '' do
      begin
         is_period_exist := false;
         j := 0;
         while (j < MAX_CORRECT_LINES) and (is_period_exist = false) do
         begin
            if (array_of_person[i].profession = array_of_qualification[j].profession) then
            begin
               is_period_exist := true;
               if IsLesser(array_of_person[i].certificate, input_date) then
               begin
                  if (DateDifference(input_date, array_of_person[i].certificate) >=
                     array_of_qualification[j].period) then
                  begin
                     output_table[non_passed].name := array_of_person[i].name;
                     output_table[non_passed].profession := array_of_person[i].profession;
                     output_table[non_passed].certificate := array_of_person[i].certificate;
                     non_passed := non_passed + 1;
                  end;
               end else
                  writeln('WARNING : certification date for person ', array_of_person[i].name,
                          ' is bigger than the input date');
            end;
            j := j + 1;
         end;
         if is_period_exist = false then
            writeln('ERROR : there was no information about certification period ',
                    'for profession ', array_of_person[i].profession, ' in file Catalog');
         i := i + 1;
      end;

      SortByProfession(output_table);
      for i := 0 to MAX_CORRECT_LINES - 1 do
         if output_table[i].name <> '' then
         begin
            writeln(f, output_table[i].name, ' ', output_table[i].profession, ' ',
                    output_table[i].certificate.day, '/',
                    output_table[i].certificate.month, '/',
                    output_table[i].certificate.year);
         end;
   end;


end.
