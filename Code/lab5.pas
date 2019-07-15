program qq;
uses GlobalTypes;


var
    s  : string;
    f1 : text;
    info_table : TableOfPerson;

{============================================================================}
                            {Helper functions}
{============================================================================}


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
