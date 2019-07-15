unit FirstFileCheck;

Interface
   uses GlobalTypes, CorrectnessChecking;

   procedure ParseStaff (var f1 : text;
                         var array_of_person : TableOfPerson;
                         var fatal_error : boolean);

Implementation


   procedure ParseStaff (var f1 : text;
                         var array_of_person : TableOfPerson;
                         var fatal_error : boolean);
   var
      s : string;
      line_counting : word;
      line_parsed : byte;
      is_ok_name, is_ok_gender, is_ok_profession, is_ok_birth, is_ok_certificate, is_ok_compare : boolean;
      buf_name, buf_gender, buf_profession, buf_birth_string, buf_certificate_string : string;
      {buf_gender has type string for cases when input gender is not a single character}
      buf_birth_date, buf_certificate_date : Date;
   begin
      line_counting := 1;
      line_parsed := 0;

      while (not EOF(f1)) and (line_parsed <= MAX_CORRECT_LINES - 1) do
      begin
         readln(f1, s);
         is_ok_name := true;
         is_ok_gender := true;
         is_ok_profession := true;
         is_ok_birth := true;
         is_ok_certificate := true;
         is_ok_compare := false;
         buf_name := '';
         buf_gender := '';
         buf_profession := '';
         buf_birth_string := '';
         buf_certificate_string := '';

         is_ok_name := TakeField(s, buf_name);
         is_ok_gender := TakeField(s, buf_gender);
         is_ok_profession := TakeField(s, buf_profession);
         is_ok_birth := TakeField(s, buf_birth_string);
         is_ok_certificate := TakeField(s, buf_certificate_string);

         if (is_ok_name) and
               (is_ok_gender) and
               (is_ok_profession) and
               (is_ok_birth) and
               (is_ok_certificate) then
         begin
               is_ok_name := FSM_Name(buf_name, line_counting);
               is_ok_gender := FSM_Gender(buf_gender, line_counting);
               is_ok_profession := FSM_Profession(buf_profession, line_counting);
               is_ok_birth := CheckDate(buf_birth_string, 'Birth', line_counting, buf_birth_date);
               is_ok_certificate := CheckDate(buf_certificate_string, 'Certification', line_counting, buf_certificate_date);
               if is_ok_birth and is_ok_certificate then
                  is_ok_compare := (IsLesser(buf_birth_date, buf_certificate_date, line_counting)) and
                                    (DateDifference(buf_certificate_date, buf_birth_date, line_counting) > 17);


               if (is_ok_name) and
                  (is_ok_gender) and
                  (is_ok_profession) and
                  (is_ok_compare) then
               begin
                  array_of_person[line_parsed].name := buf_name;
                  array_of_person[line_parsed].gender := buf_gender[1]; {type casting}
                  array_of_person[line_parsed].profession := buf_profession;
                  array_of_person[line_parsed].birth := buf_birth_date;
                  array_of_person[line_parsed].certificate := buf_certificate_date;
                  line_parsed := line_parsed + 1;
                  if length(s) <> 0 then
                     writeln('(', line_counting, ') WARNING: line is correct, ',
                              'but there are more than 5 attributes');
               end;
         end else
               writeln('(', line_counting, ') ERROR: not enough fields in line  (5 required)');
      line_counting := line_counting + 1;
      end;
      if line_parsed = MAX_CORRECT_LINES then
         writeln('File Staff has ', MAX_CORRECT_LINES, ' correct lines, data loose is possible')
      else if line_parsed = 0 then
      begin
         writeln('File Staff has no correct information');
         fatal_error := true;
      end;
end;
end.
