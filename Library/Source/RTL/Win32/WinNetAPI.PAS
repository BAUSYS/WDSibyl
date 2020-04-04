Unit WinNetAPI;

Interface

Type TUser_Info_0 = record
       usri0_Name         : pUniCodeString;
     End;
     PUSER_INFO_0 = ^TUSER_INFO_0;

     TUser_Info_1 = record
       usri1_name         : pUniCodeString;
       usri1_password     : pUniCodeString;
       usri1_password_age : LongWord;
       usri1_priv         : LongWord;
       usri1_home_dir     : pUniCodeString;
       usri1_comment      : pUniCodeString;
       usri1_flags        : LongWord;
       usri1_script_path  : pUniCodeString;
     End;
     PUSER_INFO_1 = ^TUSER_INFO_1;

     TUSER_INFO_2 = record
       usri2_name          : PChar;
       usri2_password      : PChar;
       usri2_password_age  : LongWord;
       usri2_priv          : LongWord;
       usri2_home_dir      : PChar;
       usri2_comment       : PChar;
       usri2_flags         : LongWord;
       usri2_script_path   : PChar;
       usri2_auth_flags    : LongWord;
       usri2_full_name     : PChar;
       usri2_usr_comment   : PChar;
       usri2_parms         : PChar;
       usri2_workstations  : PChar;
       usri2_last_logon    : LongWord;
       usri2_last_logoff   : LongWord;
       usri2_acct_expires  : LongWord;
       usri2_max_storage   : LongWord;
       usri2_units_per_week: LongWord;
       usri2_logon_hours   : PBYTE;
       usri2_bad_pw_count  : LongWord;
       usri2_num_logons    : LongWord;
       usri2_logon_server  : PChar;
       usri2_country_code  : PChar;
       usri2_code_page     : LongWord;
     end;
     PUSER_INFO_2 = ^TUSER_INFO_2;

     TUSER_INFO_3=record
       usri3_name            : pChar;
       usri3_password        : pChar;
       usri3_password_age    : Longword;
       usri3_priv            : Longword;
       usri3_home_dir        : PChar;
       usri3_comment         : PChar;
       usri3_flags           : Longword;
       usri3_script_path     : PChar;
       usri3_auth_flags      : Longword;
       usri3_full_name       : PChar;
       usri3_usr_comment     : PChar;
       usri3_parms           : PChar;
       usri3_workstations    : PChar;
       usri3_last_logon      : Longword;
       usri3_last_logoff     : Longword;
       usri3_acct_expires    : Longword;
       usri3_max_storage     : Longword;
       usri3_units_per_week  : Longword;
       usri3_logon_hours     : PBYTE;
       usri3_bad_pw_count    : Longword;
       usri3_num_logons      : Longword;
       usri3_logon_server    : PChar;
       usri3_country_code    : Longword;
       usri3_code_page       : Longword;
       usri3_user_id         : Longword;
       usri3_primary_group_id: Longword;
       usri3_profile         : PChar;
       usri3_home_dir_drive  : PChar;
       usri3_password_expired: Longword;
     End;
     PUSER_INFO_3    = ^TUSER_INFO_3;

     TUSER_INFO_10 = record
       usri10_name       : PChar;
       usri10_comment    : PChar;
       usri10_usr_comment: PChar;
       usri10_full_name  : PChar;
     end;
     PUSER_INFO_10    = ^TUSER_INFO_10;

     TUser_Info_11 = packed record
       usri11_name           : pUniCodeString;
       usri11_comment        : pUniCodeString;
       usri11_usr_comment    : pUniCodeString;
       usri11_full_name      : pUniCodeString;
       usri11_priv           : LongWord;
       usri11_auth_flags     : LongWord;
       usri11_password_age   : LongWord;
       usri11_home_dir       : pUniCodeString;
       usri11_parms          : pUniCodeString;
       usri11_last_logon     : Longword;
       usri11_last_logoff    : Longword;
       usri11_bad_pw_count   : Longword;
       usri11_num_logons     : Longword;
       usri11_logon_server   : pUniCodeString;
       usri11_country_code   : Longword;
       usri11_workstations   : pUniCodeString;
       usri11_max_storage    : Longword;
       usri11_units_per_week : Longword;
       usri11_logon_hours    : Longword; //PBYTE
       usri11_code_page      : Longword;
     end;
     PUSER_INFO_11 = ^TUSER_INFO_11;

Const MAX_PREFERRED_LENGTH = -1;
      FILTER_NORMAL_ACCOUNT= $0002;


Imports
  FUNCTION NetUserGetInfo(ServerName, UserName : pUniCodeString; Level : LongWord;
                          var ptrBuffer : Pointer) : LongWord;
                      APIENTRY; 'NETAPI32' name 'NetUserGetInfo';
  FUNCTION NetUserAdd(Var ServerName : cString; Level : LongWord;
                          var ptrBuffer : Pointer; parm_err: Pointer) : LongWord;
                      APIENTRY; 'NETAPI32' name 'NetUserAdd';
  FUNCTION NetUserDel(Var ServerName, UserName : cString) : LongWord;
                      APIENTRY; 'NETAPI32' name 'NetUserDel';
  FUNCTION NetUserEnum(ServerName : pUniCodeString;Level,Filter: LongWord;var ptrBuffer: Pointer;
               PrefMaxLen: LongWord;var EntriesRead,TotalEntries,ResumeHandle: LongWord): LongWord;
                      APIENTRY; 'NETAPI32' name 'NetUserEnum';
  FUNCTION NetApiBufferFree(ptrBuffer : Pointer) : LongWord;
                      APIENTRY; 'NETAPI32' name 'NetApiBufferFree';
End;


Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  13-Aug-06  WD         Unit erstellt
}