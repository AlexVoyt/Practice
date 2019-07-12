unit FirstFileCheck;

Interface
   uses GlobalTypes;

   {TODO: used in ReadInput, dunno what to do with that}
   function IsLeapYear(year : word) : boolean;
   procedure ParseFirstFile (var f1 : text; var array_of_person : TableOfPerson);

Implementation

   function IsLeapYear(year : word) : boolean;
   begin
      IsLeapYear:= false;
      if (year mod 400 = 0) then
         IsLeapYear:= true;
   end;


   {Return variable of type Date from given day, month and year}
   function MakeDate (day, month : byte; year : word) : Date;
   begin
      MakeDate.day := day;
      MakeDate.month := month;
      MakeDate.year := year;
   end;


   {TODO: fix side effect}
   {Cuts field in "source" up to space character and puts it in "field".
   Returns false, if source is empty string}
   function TakeField(var source, field : string) : boolean;
   begin
      TakeField := true;
      if source = '' then
         TakeField := false
      else
      begin
         while (length(source) > 0) and (source[1] = ' ') do
               delete(source, 1, 1);
         if pos(' ', source) <> 0 then
         begin
               field := copy(source, 1, pos(' ', source) - 1);
               delete(source, 1, pos(' ', source));
         end
         else
         begin
               field := copy(source, 1, length(source));
               delete(source, 1, length(s));
         end;
      end;
   end;


   {TODO: fix side effect}
   {Overloaded for char}
   function TakeField(var source : string; field : char) : boolean;
   begin
      TakeField := true;
      if source = '' then
         TakeField := false
      else
      begin
         while (length(source) > 0) and (source[1] = ' ') do
               delete(source, 1, 1);
         if pos(' ', source) <> 0 then
         begin
               field := copy(source, 1, pos(' ', source) - 1);
               delete(source, 1, pos(' ', source));
         end
         else
         begin
               field := copy(source, 1, length(source));
               delete(source, 1, length(s));
         end;
      end;
   end;


   {========================== Section for error messages ============================}

   procedure PrintNameError(line_counting : integer; s : string);
   begin
      writeln('(', line_cointing, ') ERROR: name ', s, 'must consist of surname,
               that starts with with capital letter, followed by small latin
               and initials, that are capital lati letters, separated by dots, for example: Surname.S.S');
   end;


   procedure PrintGenderError(line_counting : integer; s : string);
   begin
      writeln('(', line_cointing, ') ERROR: gender ', s, 'must be either F or M');
   end;


   function FSM_Name(s : string; line_counting : integer) : boolean;
   var
      symbol : char;
      state : Name_States;
      i: byte;
   begin
      FSM_Name := true;
      i := 1;
      state := InitialName;
      while (i <= length(s)) and (FSM_Name = true) do
      begin
         symbol := s[i];
         case state of
               InitialName:
                  if (symbol >= 'A') and (symbol <= 'Z') then
                     state := Surname
                  else
                     FSM_Name := false;

               Surname:
                  if (symbol >= 'a') and (symbol <= 'z') then
                     state := Surname
                  else if symbol = '.' then
                     state := SurnameDot
                  else
                     FSM_Name := false;

               SurnameDot:
                  if (symbol >= 'A') and (symbol <= 'Z') then
                     state := Name
                  else
                     FSM_Name := false;

               Name:
                  if symbol = '.' then
                     state := NameDot
                  else
                     FSM_Name := false;

               NameDot:
                  if (symbol >= 'A') and (symbol <= 'Z') then
                     state := EndOfName
                  else
                     FSM_Name := false;

               EndOfName:
                  FSM_Name := false;

         end;
         i := i + 1;
      end;
      if FSM_Name = false then
         PrintNameError(line_counting, s);
   end;


   function FSM_Gender (s : string; line_counting : integer) : boolean;
   var
      symbol : char;
      state : Gender_States;
      i: byte;
   begin
      FSM_Gender:= true;
      i := 1;
      state := InitialGender;
      while (i <= length(s)) and (FSM_Gender = true) do
      begin
         symbol := s[i];
         case state of
               InitialGender:
                  if (symbol = 'M') or (symbol = 'F') then
                     state := EndOfGender
                  else
                     FSM_Gender := false;

               EndOfGender:
                  FSM_Gender := false;
         end;

         i := i + 1;
      end;
      if (FSM_Gender = false) then
         PrintGenderError(line_counting, s);
   end;


   function FSM_Profession (s : string; line_counting : integer) : boolean;
   var
      symbol : char;
      state : Profession_States;
      i: byte;
   begin
      FSM_Profession := true;
      i := 1;
      state := InitialProfession;
      while (i <= length(s)) and (FSM_Profession = true) do
      begin
         symbol := s[i];
         case state of
               InitialProfession:
                  if (symbol >= 'A') and (symbol <= 'Z') then
                     state := LowerCaseProfession
                  else
                     FSM_Profession := false;

               LowerCaseProfession:
                  if (symbol >= 'a') and (symbol <= 'z') then
                     state := LowerCaseProfession
                  else
                     FSM_Profession := false;
         end;

         i := i + 1;
      end;
      if (FSM_Profession = false) then
         Print_Error('Profession', line_counting);
   end;


   procedure ParseFirstFile (var f1 : text; var array_of_person : TableOfPerson);
   var
      line_counting : integer;
      line_parsed : byte;
      is_ok_name, is_ok_gender, is_ok_profession, is_ok_birth, is_ok_certificate, is_ok_compare : boolean;
      buf_name, buf_profession, buf_birth_string, buf_certificate_string : string;
      buf_gender : char;
      buf_birth_date, buf_certificate_date : Date;
   begin
      line_counting := 1;
      line_parsed := 0;
      while (not EOF(f1)) and (line_parsed <= 99) do
      begin
         readln(f1, s);
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
               is_ok_birth := Check_Date(buf_birth_string, 'Birth', line_counting, buf_birth_date);
               is_ok_certificate := Check_Date(buf_certificate_string, 'Certificate', line_counting, buf_certificate_date);
               if is_ok_birth and is_ok_certificate then
                  is_ok_compare := Is_Lesser(buf_birth_string, buf_certificate_string, line_counting);

               if (is_ok_name) and
                  (is_ok_gender) and
                  (is_ok_profession) and
                  (is_ok_birth) and
                  (is_ok_certificate) and
                  (is_ok_compare) then
               begin
                  array_of_person[line_parsed].name := buf_name;
                  array_of_person[line_parsed].gender := buf_gender;
                  array_of_person[line_parsed].profession := buf_profession;
                  array_of_person[line_parsed].birth := buf_birth_date;
                  array_of_person[line_parsed].certificate := buf_certificate_date;
                  line_parsed := line_parsed + 1;
                  if length(s) <> 0 then
                     writeln('(', line_counting, ') WARNING: line  succesfully parsed, but there are more fields left');
               end;
         end else
               writeln('(', line_counting, ') ERROR: not enough fields in line  (5 required)');
      line_counting := line_counting + 1;
      end;
end;
end.
