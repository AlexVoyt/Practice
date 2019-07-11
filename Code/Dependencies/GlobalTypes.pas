unit GlobalTypes;

Interface
   const MAX_CORRECT_LINES = 100;

type
   {Used for checking file Staff}
   Name_States = (InitialName, Surname, SurnameDot, Name, NameDot, EndOfName);
   Gender_States = (InitialGender, EndOfGender);
   Profession_States = (InitialProfession, LowerCaseProfession, EndOfProfession);

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
   TableOfQualification = arrat [0..MAX_CORRECT_LINES-1] of Qualification;

Implementation

begin

end.
