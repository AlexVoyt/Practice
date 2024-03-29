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
      cp, inp : Date;
      day, month : string;
   begin
      i := 0;
      non_passed := 0;
      while (i < MAX_CORRECT_LINES) and (array_of_person[i].name <> '') do
      begin
         is_period_exist := false;
         j := 0;
         while (j < MAX_CORRECT_LINES) and (is_period_exist = false) do
         begin
            if (array_of_person[i].profession = array_of_qualification[j].profession) then
            begin
               is_period_exist := true;
               cp := IncYear(array_of_person[i].certificate, array_of_qualification[j].period);
               if IsLesser(cp, input_date) then
                  begin
                     output_table[non_passed].name := array_of_person[i].name;
                     output_table[non_passed].profession := array_of_person[i].profession;
                     output_table[non_passed].certificate := array_of_person[i].certificate;
                     non_passed := non_passed + 1;
                  end;
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
            {Normalizing day and month if needed}
            if (output_table[i].certificate.day >= 1) and
               (output_table[i].certificate.day <= 9) then
            begin
               str(output_table[i].certificate.day, day);
               day := '0' + day;
            end
            else
               str(output_table[i].certificate.day, day);

            if (output_table[i].certificate.month >= 1) and
               (output_table[i].certificate.month <= 9) then
            begin
               str(output_table[i].certificate.month, month);
               month := '0' + month;
            end
            else
               str(output_table[i].certificate.month, month);

            writeln(f, output_table[i].name, ' ', output_table[i].profession, ' ',
                    day, '/',
                    month, '/',
                    output_table[i].certificate.year);
         end;
   end;


end.
