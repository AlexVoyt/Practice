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

function IsLeapYear(y:integer):boolean;
begin
    IsLeapYear:= false;
    if (y mod 400 = 0) or ((y mod 4 = 0) and (y mod 100 <> 0)) then
    IsLeapYear:= true;
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
        if (IsLeapYear(y)) and (d > 29) then
                Is_Date_Correct := false;
        if (not(IsLeapYear(y))) and (d > 28) then
                Is_Date_Correct := false;
        end;
    end;
end;


procedure Print_Error(expected_string : string; row: integer);
begin
    writeln('(', row,  ') ERROR: at ', expected_string);
end;




{Return variable of type Date from given day, month and year}
function MakeDate (day, month, year : integer) : Date;
begin
    MakeDate.day := day;
    MakeDate.month := month;
    MakeDate.year := year;
end;

{============================================================================}
            {Realization of correctness checking}
{============================================================================}




function FSM_Gender (s : string; line_counting : integer) : boolean;
var
    symbol : char;
    state : Gender_States;
    i: integer;
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
        output_date := MakeDate(d, m, y);

end;



{============================================================================}

{============================================================================}


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
