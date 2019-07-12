unit GlobalTypes;

Interface
   const MAX_CORRECT_LINES = 100;

type
   {Used for checking files}
   Name_States = (InitialName, Surname, SurnameDot, Name, NameDot, EndOfName);
   Gender_States = (InitialGender, EndOfGender);
   Profession_States = (InitialProfession, LowerCaseProfession, EndOfProfession);

   ErrorTypes = (NAME, GENDER, PROFESSION, BIRTH_YEAR, BIRTH_MONTH, BIRTH_DAY_31,
                 BIRTH_DAY_30, BIRTH_DAY_29, BIRTH_DAY_28, BIRTH_SEPARATOR,
                 CERTIFICATION_YEAR, CERTIFICATION_MONTH, CERTIFICATION_DAY_31,
                 CERTIFICATION_DAY_30, CERTIFICATION_DAY_29, CERTIFICATION_DAY_28,
                 CERTIFICATION_SEPARATOR, DATE_DIFFERENCE, STAFF_MISSING_ATTRIBUTES,
                 STAFF_MISSING_PERIOD, STAFF_MORE_ATTRIBUTES, STAFF_HUNDRED_LINES,
                 PERIOD, CATALOG_STRUCTURE, CATALOG_SPACE, CATALOG_EQUAL_PROFESSIONS,
                 CATALOG_MISSING_ATTRIBUTES, CATALOG_MORE_ATTRIBUTES, CATALOG_HUNDRED_LINES);

   Date = record
      day : integer;
      month : integer;
      year : integer;
   end;

   Person = record
      name : string;
      gender : string; {TODO change to char}
      profession : string;
      birth : Date;
      certificate : Date;
   end;

   Qualification = record
      period : byte;
      profession : string;
   end;

   TableOfPerson = array [0..MAX_CORRECT_LINES-1] of Person;
   TableOfQualification = array [0..MAX_CORRECT_LINES-1] of Qualification;

Implementation

begin

end.
