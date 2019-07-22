unit CorrectnessChecking;

Interface
   uses GlobalTypes;


   {Return date with month increased by 1}
   function IncMonth(date : Date) : Date;


   {Return date with year increased by num}
   function IncYear(date : Date; num : byte) : Date;


   function IsLeapYear(year : word) : boolean;

   {Return variable of type Date from given day, month and year}
   function MakeDate (day, month : shortint; year : smallint) : Date;

   {Checks if numerical values of day, month and year are correct}
   function IsDateCorrect(line_counting : word;
                          d, m : shortint; y : smallint; date, param : string) : boolean;

   {Cuts field in "source" up to space character and puts it in "field".
   Returns false, if source is empty string}
   function TakeField(var source, field : string) : boolean;

   function FSM_Name(s : string; line_counting : word) : boolean;

   function FSM_Gender (s : string; line_counting : word) : boolean;

   function FSM_Profession (s : string; line_counting : word) : boolean;

   function CheckDate (date, param : string; line_counting : word; var output_date : Date) : boolean;

   {Returns true, if left date happened earlier than right date}
   function IsLesser(left, right : Date; line_counting : word) : boolean; overload;

   {Returns how much years passed since right date}
   function DateDifference(left, right : Date; line_counting : word) : byte; overload;

   {overloaded for SelectStaff}
   function IsLesser(left, right : Date) : boolean; overload;

   {overloaded for SelectStaff}
   function DateDifference(left, right : Date) : byte; overload;

   procedure SortByProfession(var table : InfoTable);

Implementation


   function IsLeapYear(year : word) : boolean;
   begin
      IsLeapYear:= false;
      if (year mod 4 = 0) then
         IsLeapYear:= true;
   end;


   function MakeDate (day, month : shortint; year : smallint) : Date;
   begin
      MakeDate.day := day;
      MakeDate.month := month;
      MakeDate.year := year;
   end;


   function IsDateCorrect(line_counting : word;
                          d, m : shortint; y : smallint; date, param : string) : boolean;
   var min_bound, max_bound : word;
   begin
      IsDateCorrect:= true;
      if param = 'Birth' then
      begin
         min_bound := 1950;
         max_bound := 2000;
      end
      else if param = 'Certification' then
      begin
         min_bound := 2000;
         max_bound := 2017;
      end;

      if (y < min_bound) or (y > max_bound) then
      begin
         IsDateCorrect := false;
         writeln('(', line_counting, ') ERROR: ', param, ' date ',
                  'year ', date, ' must be in range [', min_bound, '..', max_bound, ']');
      end;
      if (m < 1) or (m > 12) then
      begin
         IsDateCorrect := false;
         writeln('(', line_counting, ') ERROR: ', param, ' date ',
                  'month ', date, ' must be in range [1..12]');
      end;
      case m of
      1,3,5,7,8,10,12:
         if (d < 1) or (d > 31) then
         begin
            IsDateCorrect := false;
            writeln('(', line_counting, ') ERROR: ', param, ' date ',
                     'day ', date, ' must be in range [1..31]');
         end;
      4,6,9,11:
         if (d < 1) or (d > 30) then
         begin
            IsDateCorrect := false;
            writeln('(', line_counting, ') ERROR: ', param, ' date ',
                     'day ', date, ' must be in range [1..30]');
         end;
      2:
         begin
            if (IsLeapYear(y)) and ((d < 1) or (d > 29)) then
            begin
               IsDateCorrect := false;
               writeln('(', line_counting, ') ERROR: ', param, ' date ',
                        'day ', date, ' must be in range [1..29]');
            end;
            if (not(IsLeapYear(y))) and ((d < 1) or (d > 28)) then
            begin
               IsDateCorrect := false;
               writeln('(', line_counting, ') ERROR: ', param, ' date ',
                        'day ', date, ' must be in range [1..28]');
            end;
         end;
      end;
   end;


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
               delete(source, 1, length(source));
         end;
      end;
   end;


   function FSM_Name(s : string; line_counting : word) : boolean;
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
         writeln('(', line_counting, ') ERROR: name ', s, ' must consist of surname, ',
                  'that starts with with capital letter, followed by small latin ',
                  'and initials, that are capital lati letters, separated by dots, for example: Surname.S.S');
   end;


   function FSM_Gender (s : string; line_counting : word) : boolean;
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
         writeln('(', line_counting, ') ERROR: gender ', s, ' must be either F or M');
   end;


   function FSM_Profession (s : string; line_counting : word) : boolean;
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
         writeln('(', line_counting, ') ERROR: profession ', s, ' must start with capital letter ',
                  'and other symbols must be only small latin letters');
   end;


   function CheckDate (date, param : string; line_counting : word; var output_date : Date) : boolean;
   var
      d, m, error : byte;
      y : word;
      ds, ms, ys : string;
   begin
      CheckDate := true;
      if length(date) <> 10 then
      begin
         CheckDate := false;
         writeln('(', line_counting, ') ERROR: ', param, ' date ', date, ' must be 10 symbols long');
      end;

      if CheckDate = true then
         if (date[3] <> '/') or (date[6] <> '/') then
         begin
            CheckDate := false;
            writeln('(', line_counting, ') ERROR: day, month and year in ', param, ' date ', date,
                     ' must be separated with symbol /');
         end;

      if CheckDate = true then
      begin
         ds := copy(date, 1, 2);
         ms := copy(date, 4, 2);
         ys := copy(date, 7, 4);
         val(ds, d, error);
         if error > 0 then
         begin
            writeln('(', line_counting, ') ERROR: ', param, ' date day is not a number ', date);
            CheckDate := false;
         end;
         val(ms, m, error);
         if error > 0 then
         begin
            writeln('(', line_counting, ') ERROR: ', param, ' date month is not a number ', date);
            CheckDate := false;
         end;
         val(ys, y, error);
         if error > 0 then
         begin
            writeln('(', line_counting, ') ERROR: ', param, ' date year is not a number ', date);
            CheckDate := false;
         end;
      end;


      if CheckDate = true then
         CheckDate := IsDateCorrect(line_counting, d, m, y, date, param);

      if CheckDate = true then
         output_date := MakeDate(d, m, y);

   end;


   function IsLesser(left, right : Date; line_counting : word):boolean;
   begin
      IsLesser := false;

      if (left.year < right.year) then
         IsLesser := true
      else if (left.year = right.year) and (left.month < right.month) then
         IsLesser := true
      else if (left.year = right.year) and (left.month = right.month) and (left.day < right.day) then
         IsLesser := true;

      if IsLesser = false then
         writeln('(', line_counting ,') ERROR: certification date is lesser than the birth date');
   end;


   function DateDifference(left, right : Date; line_counting : word) : byte;
   begin
      if (left.month > right.month) or
         ((left.month = right.month) and (left.day >= right.day)) then
            DateDifference := left.year - right.year
      else
            DateDifference := left.year - right.year - 1;
      if DateDifference <= 17 then
         writeln('(', line_counting,') ERROR: difference between birth date and ',
                  'certification date must be greater than 17 years')
   end;


   {Overloaded for SelectStaff}
   function IsLesser(left, right : Date):boolean;
   begin
      IsLesser := false;

      if (left.year < right.year) then
         IsLesser := true
      else if (left.year = right.year) and (left.month < right.month) then
         IsLesser := true
      else if (left.year = right.year) and (left.month = right.month) and (left.day < right.day) then
         IsLesser := true;

   end;


   {Overloaded for SelectStaff}
   function DateDifference(left, right : Date) : byte;
   begin
      if (left.month > right.month) or
         ((left.month = right.month) and (left.day >= right.day)) then
            DateDifference := left.year - right.year
      else
            DateDifference := left.year - right.year - 1;
   end;


   procedure SortByProfession(var table : InfoTable);
   var
      tmp : Info;
      i, j : word;
   begin
      for i := 0 to MAX_CORRECT_LINES - 2 do
         for j := i + 1 to MAX_CORRECT_LINES - 1 do
            if table[i].profession > table[j].profession then
            begin
               tmp := table[i];
               table[i] := table[j];
               table[j] := tmp;
            end;
   end;


   function IncYear(date : Date; num : byte) : Date;
   begin
      IncYear.year := date.year + num;
      IncYear.month := date.month;
      IncYear.day := date.day;
   end;


   function IncMonth(date : Date) : Date;
   begin
      IncMonth.day := date.day;
      if date.month = 12 then
      begin
         IncMonth.month := 1;
         IncMonth.year := date.year + 1;
      end else
      begin
         IncMonth.month := date.month + 1;
         IncMonth.year := date.year;
      end;
   end;


end.
