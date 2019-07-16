unit SecondFileCheck;

Interface
   uses GlobalTypes, CorrectnessChecking;

   procedure ParseCatalog(var f1 : text;
                          var array_of_qualification : TableOfQualification;
                          var fatal_error : boolean);

Implementation

   procedure ParseCatalog(var f1 : text;
                          var array_of_qualification : TableOfQualification;
                          var fatal_error : boolean);
   var
      s : string;
      line_counting : word;
      line_parsed, i, period, error : byte;
      buf_period, buf_profession : string;
      is_ok_period, is_ok_profession, is_ok_structure : boolean;
   begin
      line_counting := 1;
      line_parsed := 0;

      while (not EOF(f1)) and (line_parsed <= MAX_CORRECT_LINES - 1) do
      begin
         is_ok_structure := true;
         is_ok_profession := true;
         is_ok_period := true;
         buf_period := '';
         buf_profession := '';
         readln(f1, s);
         if length (s) >= 3 then
         begin
            if s[2] <> ' ' then
            begin
               writeln('(', line_counting, ') ERROR: second symbol must be space character');
               is_ok_structure := false;
            end;

            if is_ok_structure and (s[3] = ' ') then
            begin
               writeln('(', line_counting, ') ERROR: there must be only one space character ',
                        'between certification period and profession');
               is_ok_structure := false;
            end;

            if is_ok_structure then
            begin
               if (s[1] < '1') or (s[1] > '3') then
               begin
                  writeln('(', line_counting, ') ERROR: period must be first ',
                           'character in line, in range [1..3] ');
                  is_ok_period := false;
               end;

               {We do not need in returning value here}
               TakeField(s, buf_period);
               is_ok_profession := TakeField(s, buf_profession);
               val(buf_period, period, error);

               if (is_ok_period) and (is_ok_profession) then
               begin
                  is_ok_profession := FSM_Profession(buf_profession, line_counting);
                  if is_ok_profession then
                  begin
                     for i := 0 to MAX_CORRECT_LINES - 1 do
                        if (buf_profession = array_of_qualification[i].profession) and
                           (period <> array_of_qualification[i].period) then
                        begin
                           writeln('(', line_counting, ') FATAL: profession ', buf_profession,
                                    ' is repeating with different period');
                           fatal_error := true;
                        end;

                     if fatal_error = false then
                     begin
                        array_of_qualification[line_parsed].period := period;
                        array_of_qualification[line_parsed].profession := buf_profession;
                        line_parsed := line_parsed + 1;
                     end;
                  end;
               end else
                  writeln('(', line_counting, ') ERROR: not enought attributes, 2 required');
            end;
         end else
            writeln('(', line_counting, ') ERROR: not enought attributes, 2 required');
         line_counting := line_counting + 1;
      end;

      if line_parsed = MAX_CORRECT_LINES then
         writeln('File Catalog has ', MAX_CORRECT_LINES, ' correct lines, data loose is possible')
      else if line_parsed = 0 then
      begin
         writeln('File Staff has no correct information');
         fatal_error := true;
      end;

   end;

end.
