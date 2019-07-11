program qq;
uses GlobalTypes;


var
    s  : string;
    f1 : text;
    info_table : TableOfPerson;

{============================================================================}
                            {Helper functions}
{============================================================================}

{Determines if the left date is lesser than the right one}
function Is_Lesser(l, r : string; line_counting : integer):boolean;
var
    yearL,  yearR,
    monthL, monthR,
    dayL,   dayR : string;

    yearLNum,  yearRNum,
    monthLNum, monthRNum,
    dayLNum,   dayRNum, err : integer;
begin
    Is_Lesser := false;

    yearL := copy(l, 7, 4);
    yearR := copy(r, 7, 4);

    val(yearL, yearLNum, err);
    val(yearR, yearRNum, err);

    monthL := copy(l, 4, 2);
    monthR := copy(r, 4, 2);

    val(monthL, monthLNum, err);
    val(monthR, monthRNum, err);

    dayL := copy(l, 1, 2);
    dayR := copy(r, 1, 2);

    val(dayL, dayLNum, err);
    val(dayR, dayRNum, err);

    if (yearLNum < yearRNum) then
        Is_Lesser := true
    else if (yearLNum = yearRNum) and (monthLNum < monthRNum) then
        Is_Lesser := true
    else if (yearLNum = yearRNum) and (monthLNum = monthRNum) and (dayLNum < dayRNum) then
        Is_Lesser := true;

    if Is_Lesser = false then
        writeln('(', line_counting ,') ERROR: birth date is lesser than the certification date');

end;


procedure Print_Array (var arr : TableOfPerson);
var
    i : integer;
begin
    for i := 0 to 99 do
        if arr[i].name <> '' then
        begin
            writeln('-----------------------');
            writeln('Index - ', i);
            writeln('Name - ', arr[i].name);
            writeln('Gender - ', arr[i].gender);
            writeln('Profession - ', arr[i].profession);
            writeln('Birth date - ', arr[i].birth.day, '/', arr[i].birth.month, '/', arr[i].birth.year);
            writeln('Certification date - ', arr[i].certificate.day, '/', arr[i].certificate.month, '/', arr[i].certificate.year);
        end;
end;

function IsVisoch(y:integer):boolean;
begin
    IsVisoch:= false;
    if (y mod 400 = 0) or ((y mod 4 = 0) and (y mod 100 <> 0)) then
    IsVisoch:= true;
end;


function Is_Date_Correct(d, m, y:integer):boolean;
begin
    Is_Date_Correct:= true;
    if (y < 1950) or (y > 2017) then
        Is_Date_Correct := false;
    if (m < 1) or (m > 12) then
        Is_Date_Correct := false;
    if (d < 1) then
        Is_Date_Correct := false;
    case m of
    1,3,5,7,8,10,12:
        if (d > 31) then
            Is_Date_Correct := false;
    4,6,9,11:
        if (d > 30) then
            Is_Date_Correct := false;
    2:
        begin
        if (IsVisoch(y)) and (d > 29) then
                Is_Date_Correct := false;
        if (not(IsVisoch(y))) and (d > 28) then
                Is_Date_Correct := false;
        end;
    end;
end;


procedure Print_Error(expected_string : string; row: integer);
begin
    writeln('(', row,  ') ERROR: at ', expected_string);
end;


{Return true, if succesfully take a part}
function Take_Part(var source, part : string) : boolean;
begin
    Take_Part := true;
    if source = '' then
        Take_Part := false
    else
    begin
        while (length(source) > 0) and (source[1] = ' ') do
            delete(source, 1, 1);
        if pos(' ', source) <> 0 then
        begin
            part := copy(source, 1, pos(' ', source) - 1);
            delete(source, 1, pos(' ', source));
        end
        else
        begin
            part := copy(source, 1, length(source));
            delete(source, 1, length(s));
        end;
    end;
end;


{Return variable of type Date from given day, month and year}
function Make_Date (day, month, year : integer) : Date;
begin
    Make_date.day := day;
    Make_date.month := month;
    Make_date.year := year;
end;

{============================================================================}
            {Realization of correctness checking}
{============================================================================}


function FSM_Name(s : string; line_counting : integer) : boolean;
var
    symbol : char;
    state : Name_States;
    i: integer;
begin
    FSM_Name := true;
    i := 1;
    state := InitialName;
    while (i <= length(s)) and (state <> EndOfName) and (FSM_Name = true) do
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

        end;
        i := i + 1;
    end;
    if (state <> EndOfName) or (FSM_Name = false) then
        Print_Error('Name', line_counting);
end;


function FSM_Gender (s : string; line_counting : integer) : boolean;
var
    symbol : char;
    state : Gender_States;
    i: integer;
begin
    FSM_Gender:= true;
    i := 1;
    state := InitialGender;
    while (i <= length(s)) and (state <> EndOfGender) and (FSM_Gender = true) do
    begin
        symbol := s[i];
        case state of
            InitialGender:
                if (symbol = 'M') or (symbol = 'F') then
                    state := EndOfGender
                else
                    FSM_Gender := false;
        end;

        i := i + 1;
    end;
    if (state <> EndOfGender) or (FSM_Gender = false) then
        Print_Error('Gender', line_counting);
end;


function FSM_Profession (s : string; line_counting : integer) : boolean;
var
    symbol : char;
    state : Profession_States;
    i: integer;
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
    if (state <> LowerCaseProfession) or (FSM_Profession = false) then
        Print_Error('Profession', line_counting);

end;


function Check_Date (date, param : string; line_counting : integer; var output_date : Date) : boolean;
var
    d, m, y, error : integer;
    ds, ms, ys : string;
begin
    Check_Date := true;
    if length(date) <> 10 then
        Check_Date := false;
    if (date[3] <> '/') or (date[6] <> '/') then
        Check_Date := false;

    if Check_Date = true then
    begin
        ds := copy(date, 1, 2);
        ms := copy(date, 4, 2);
        ys := copy(date, 7, 4);
        val(ds, d, error);
        if error > 0 then
            Check_Date := false;
        val(ms, m, error);
        if error > 0 then
            Check_Date := false;
        val(ys, y, error);
        if error > 0 then
            Check_Date := false;
    end;

    if Check_Date = true then
      Check_Date := Is_Date_Correct(d, m, y);

    if Check_Date = false then
        Print_Error(param, line_counting)
    else
        output_date := Make_Date(d, m, y);

end;



{============================================================================}

{============================================================================}
procedure Parse_First_File (var f1 : text; var array_of_person : TableOfPerson);
var
    line_counting, line_parsed : integer;
    is_ok_name, is_ok_gender, is_ok_profession, is_ok_birth, is_ok_certificate, is_ok_compare : boolean;
    buf_name, buf_gender, buf_profession, buf_birth_string, buf_certificate_string : string;
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

        is_ok_name := Take_Part(s, buf_name);
        is_ok_gender := Take_Part(s, buf_gender);
        is_ok_profession := Take_Part(s, buf_profession);
        is_ok_birth := Take_Part(s, buf_birth_string);
        is_ok_certificate := Take_Part(s, buf_certificate_string);

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

begin
    assign(f1, 'input.txt');
    reset(f1);
    writeln();
    writeln('-------------------------');
    writeln();
    Parse_First_File(f1, info_table);
    close(f1);
    Print_Array(info_table);
end.
