unit GlobalTypes;

Interface
   const MAX_CORRECT_LINES = 100;

type
   {Used for checking files}
   Name_States = (InitialName, Surname, SurnameDot, Name, NameDot, EndOfName);
   Gender_States = (InitialGender, EndOfGender);
   Profession_States = (InitialProfession, LowerCaseProfession, EndOfProfession);


   Date = record
      day : byte;
      month : byte;
      year : word;
   end;

   Person = record
      name : string;
      gender : char;
      profession : string;
      birth : Date;
      certificate : Date;
   end;


   Qualification = record
      period : byte;
      profession : string;
   end;


   {Resulting information}
   Info = record
      name : string;
      profession : string;
      certificate : Date;
   end;


   TableOfPerson = array [0..MAX_CORRECT_LINES - 1] of Person;
   TableOfQualification = array [0..MAX_CORRECT_LINES - 1] of Qualification;
   InfoTable = array [0..MAX_CORRECT_LINES - 1] of Info;

Implementation

begin

end.
