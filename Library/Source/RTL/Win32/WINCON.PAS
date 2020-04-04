
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT WinCon;

INTERFACE

USES WinNT,WinDef;

TYPE
    PCOORD=^COORD;
    COORD=RECORD
                X:INTEGER;
                Y:INTEGER;
    END;

    PSMALL_RECT=^SMALL_RECT;
    SMALL_RECT=RECORD
                     Left:INTEGER;
                     Top:INTEGER;
                     Right:INTEGER;
                     Bottom:INTEGER;
    END;

    PKEY_EVENT_RECORD=^KEY_EVENT_RECORD;
    KEY_EVENT_RECORD=RECORD
                           bKeyDown:BOOL;
                           wRepeatCount:WORD;
                           wVirtualKeyCode:WORD;
                           wVirtualScanCode:WORD;
                           uChar:RECORD
                                    CASE Integer OF
                                      1:(UnicodeChar:WORD);
                                      2:(AsciiChar:CHAR);
                                 END;
                           dwControlKeyState:LONGWORD;
    END;

CONST
     RIGHT_ALT_PRESSED     =$0001;
     LEFT_ALT_PRESSED      =$0002;
     RIGHT_CTRL_PRESSED    =$0004;
     LEFT_CTRL_PRESSED     =$0008;
     SHIFT_PRESSED         =$0010;
     NUMLOCK_ON            =$0020;
     SCROLLLOCK_ON         =$0040;
     CAPSLOCK_ON           =$0080;
     ENHANCED_KEY          =$0100;

TYPE
    PMOUSE_EVENT_RECORD=^MOUSE_EVENT_RECORD;
    MOUSE_EVENT_RECORD=RECORD
                             dwMousePosition:COORD;
                             dwButtonState:LONGWORD;
                             dwControlKeyState:LONGWORD;
                             dwEventFlags:LONGWORD;
    END;

CONST
      FROM_LEFT_1ST_BUTTON_PRESSED    =$0001;
      RIGHTMOST_BUTTON_PRESSED        =$0002;
      FROM_LEFT_2ND_BUTTON_PRESSED    =$0004;
      FROM_LEFT_3RD_BUTTON_PRESSED    =$0008;
      FROM_LEFT_4TH_BUTTON_PRESSED    =$0010;

      MOUSE_MOVED                     =$0001;
      DOUBLE_CLICK                    =$0002;

TYPE
    PWINDOW_BUFFER_SIZE_RECORD=^WINDOW_BUFFER_SIZE_RECORD;
    WINDOW_BUFFER_SIZE_RECORD=RECORD
                                    dwSize:COORD;
    END;

    PMENU_EVENT_RECORD=^MENU_EVENT_RECORD;
    MENU_EVENT_RECORD=RECORD
                            dwCommandId:LONGWORD;
    END;

    PFOCUS_EVENT_RECORD=^FOCUS_EVENT_RECORD;
    FOCUS_EVENT_RECORD=RECORD
                             bSetFocus:BOOL;
    END;

    PINPUT_RECORD=^INPUT_RECORD;
    INPUT_RECORD=RECORD
                       EventType:WORD;
                       Event:RECORD
                         CASE Integer OF
                           1:(KeyEvent:KEY_EVENT_RECORD);
                           2:(MouseEvent:MOUSE_EVENT_RECORD);
                           3:(WindowBufferSizeEvent:WINDOW_BUFFER_SIZE_RECORD);
                           4:(MenuEvent:MENU_EVENT_RECORD);
                           5:(FocusEvent:FOCUS_EVENT_RECORD);
                       END;
    END;

CONST
      KEY_EVENT                =$0001;
      MOUSE_EVENT              =$0002;
      WINDOW_BUFFER_SIZE_EVENT =$0004;
      MENU_EVENT               =$0008;
      FOCUS_EVENT              =$0010;

TYPE
    PCHAR_INFO=^CHAR_INFO;
    CHAR_INFO=RECORD
                    Char:RECORD
                       CASE Integer OF
                           1:(UniCodeChar:WORD);
                           2:(AsciiChar:CHAR);
                    END;
                    Attributes:WORD;
    END;

CONST
      FOREGROUND_BLUE      =$0001;
      FOREGROUND_GREEN     =$0002;
      FOREGROUND_RED       =$0004;
      FOREGROUND_INTENSITY =$0008;
      BACKGROUND_BLUE      =$0010;
      BACKGROUND_GREEN     =$0020;
      BACKGROUND_RED       =$0040;
      BACKGROUND_INTENSITY =$0080;


TYPE
    PCONSOLE_SCREEN_BUFFER_INFO=^CONSOLE_SCREEN_BUFFER_INFO;
    CONSOLE_SCREEN_BUFFER_INFO=RECORD
                                     dwSize:COORD;
                                     dwCursorPosition:COORD;
                                     wAttributes:WORD;
                                     srWindow:SMALL_RECT;
                                     dwMaximumWindowSize:COORD;
    END;

    PCONSOLE_CURSOR_INFO=^CONSOLE_CURSOR_INFO;
    CONSOLE_CURSOR_INFO=RECORD
                              dwSize:LONGWORD;
                              bVisible:BOOL;
    END;

TYPE
    PHANDLER_ROUTINE=FUNCTION(CtrlType:LONGWORD):BOOL;APIENTRY;

CONST
      CTRL_C_EVENT        =0;
      CTRL_BREAK_EVENT    =1;
      CTRL_CLOSE_EVENT    =2;
      CTRL_LOGOFF_EVENT   =5;
      CTRL_SHUTDOWN_EVENT =6;

      ENABLE_PROCESSED_INPUT =$0001;
      ENABLE_LINE_INPUT      =$0002;
      ENABLE_ECHO_INPUT      =$0004;
      ENABLE_WINDOW_INPUT    =$0008;
      ENABLE_MOUSE_INPUT     =$0010;

      ENABLE_PROCESSED_OUTPUT    =$0001;
      ENABLE_WRAP_AT_EOL_OUTPUT  =$0002;


IMPORTS

FUNCTION PeekConsoleInput(hConsoleInput:HANDLE;VAR lpBuffer:INPUT_RECORD;
                          nLength:LONGWORD;VAR lpNumberOfEventsRead:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'PeekConsoleInputA';
FUNCTION ReadConsoleInput(hConsoleInput:HANDLE;VAR lpBuffer:INPUT_RECORD;
                          nLength:LONGWORD;VAR lpNumberOfEventsRead:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleInputA';
FUNCTION WriteConsoleInput(hConsoleInput:HANDLE;CONST lpBuffer:INPUT_RECORD;
                           nLength:LONGWORD;VAR lpNumberOfEventsWritten:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'WriteConsoleInputA';
FUNCTION ReadConsoleOutput(hConsoleOutput:HANDLE;VAR lpBuffer:CHAR_INFO;
                           dwBufferSize,dwBufferCoord:LONGWORD{COORD};
                           VAR lpReadRegion:SMALL_RECT):BOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleOutputA';
FUNCTION WriteConsoleOutput(hConsoleOutput:HANDLE;CONST lpBuffer:CHAR_INFO;
                            dwBufferSize,dwBufferCoord:LONGWORD{COORD};
                            VAR lpWriteRegion:SMALL_RECT):BOOL;
             APIENTRY;  'KERNEL32' name 'WriteConsoleOutputA';
FUNCTION ReadConsoleOutputCharacter(hConsoleOutput:HANDLE;VAR lpCharacter:CSTRING;
                                    nLength:LONGWORD;dwReadCoord:LONGWORD{COORD};
                                    VAR lpNumberOfCharsRead:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleOutputCharacterA';
FUNCTION ReadConsoleOutputAttribute(hConsoleOutput:HANDLE;VAR lpAttribute:WORD;
                                    nLength:LONGWORD;dwReadCoord:LONGWORD{COORD};
                                    VAR lpNumberOfAttrsRead:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleOutputAttribute';
FUNCTION WriteConsoleOutputCharacter(hConsoleOutput:HANDLE;CONST lpCharacter:CSTRING;
                                     nLength:LONGWORD;dwWriteCoord:LONGWORD{COORD};
                                     VAR lpNumberOfCharsWritten:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'WriteConsoleOutputCharacterA';
FUNCTION WriteConsoleOutputAttribute(hConsoleOutput:HANDLE;VAR lpAttribute:WORD;
                                     nLength:LONGWORD;dwWriteCoord:LONGWORD{COORD};
                                     VAR lpNumberOfAttrsWritten:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'WriteConsoleOutputAttribute';
FUNCTION FillConsoleOutputCharacter(hConsoleOutput:HANDLE;cCharacter:CHAR;
                                    nLength:LONGWORD;dwWriteCoord:LONGWORD{COORD};
                                    VAR lpNumberOfCharsWritten:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'FillConsoleOutputCharacterA';
FUNCTION FillConsoleOutputAttribute(hConsoleOutput:HANDLE;wAttribute:WORD;
                                    nLength:LONGWORD;dwWriteCoord:LONGWORD{COORD};
                                    VAR lpNumberOfAttrsWritten:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'FillConsoleOutputAttribute';
FUNCTION GetConsoleMode(hConsoleHandle:HANDLE;VAR lpMode:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'GetConsoleMode';
FUNCTION GetNumberOfConsoleInputEvents(hConsoleInput:HANDLE;
                                       VAR lpNumberOfEvents:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'GetNumberOfConsoleInputEvents';
FUNCTION GetConsoleScreenBufferInfo(hConsoleOutput:HANDLE;
                                    VAR lpConsoleScreenBufferInfo:CONSOLE_SCREEN_BUFFER_INFO):BOOL;
             APIENTRY;  'KERNEL32' name 'GetConsoleScreenBufferInfo';
FUNCTION GetLargestConsoleWindowSize(hConsoleOutput:HANDLE):LONGWORD{COORD};
             APIENTRY;  'KERNEL32' name 'GetLargestConsoleWindowSize';
FUNCTION GetConsoleCursorInfo(hConsoleOutput:HANDLE;
                              VAR lpConsoleCursorInfo:CONSOLE_CURSOR_INFO):BOOL;
             APIENTRY;  'KERNEL32' name 'GetConsoleCursorInfo';
FUNCTION GetNumberOfConsoleMouseButtons(VAR lpNumberOfMouseButtons:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'GetNumberOfConsoleMouseButtons';
FUNCTION SetConsoleMode(hConsoleHandle:HANDLE;dwMode:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleMode';
FUNCTION SetConsoleActiveScreenBuffer(hConsoleOutput:HANDLE):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleActiveScreenBuffer';
FUNCTION FlushConsoleInputBuffer(hConsoleInput:HANDLE):BOOL;
             APIENTRY;  'KERNEL32' name 'FlushConsoleInputBuffer';
FUNCTION SetConsoleScreenBufferSize(hConsoleOutput:HANDLE;dwSize:LONGWORD{COORD}):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleScreenBufferSize';
FUNCTION SetConsoleCursorPosition(hConsoleOutput:HANDLE;dwCursorPosition:LONGWORD{COORD}):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleCursorPosition';
FUNCTION SetConsoleCursorInfo(hConsoleOutput:HANDLE;
                              VAR lpConsoleCursorInfo:CONSOLE_CURSOR_INFO):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleCursorInfo';
FUNCTION ScrollConsoleScreenBuffer(hConsoleOutput:HANDLE;
                                   VAR lpScrollRectangle:SMALL_RECT;
                                   VAR lpClipRectangle:SMALL_RECT;
                                   dwDestinationOrigin:LONGWORD{COORD};
                                   VAR lpFill:CHAR_INFO):BOOL;
             APIENTRY;  'KERNEL32' name 'ScrollConsoleScreenBufferA';
FUNCTION SetConsoleWindowInfo(hConsoleOutput:HANDLE;bAbsolute:BOOL;
                              VAR lpConsoleWindow:SMALL_RECT):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleWindowInfo';
FUNCTION SetConsoleTextAttribute(hConsoleOutput:HANDLE;wAttributes:WORD):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleTextAttribute';
FUNCTION SetConsoleCtrlHandler(HandlerRoutine:PHANDLER_ROUTINE;Add:BOOL):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleCtrlHandler';
FUNCTION GenerateConsoleCtrlEvent(dwCtrlEvent,dwProcessGroupId:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'GenerateConsoleCtrlEvent';
FUNCTION AllocConsole:BOOL;
             APIENTRY;  'KERNEL32' name 'AllocConsole';
FUNCTION FreeConsole:BOOL;
             APIENTRY;  'KERNEL32' name 'FreeConsole';
FUNCTION GetConsoleTitle(VAR lpConsoleTitle:CSTRING;nSize:LONGWORD):LONGWORD;
             APIENTRY;  'KERNEL32' name 'GetConsoleTitleA';
FUNCTION SetConsoleTitle(CONST lpConsoleTitle:CSTRING):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleTitleA';
FUNCTION ReadConsole(hConsoleInput:HANDLE;VAR lpBuffer;nNumberOfCharsToRead:LONGWORD;
                     VAR lpNumberOfCharsRead:LONGWORD;lpReserved:POINTER):BOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleA';
FUNCTION WriteConsole(hConsoleOutput:HANDLE;CONST lpBuffer;nNumberOfCharsToWrite:LONGWORD;
                      VAR lpNumberOfCharsWritten:LONGWORD;lpReserved:POINTER):BOOL;
             APIENTRY;  'KERNEL32' name 'WriteConsoleA';
{FUNCTION CreateConsoleScreenBuffer(dwDesiredAccess:LONGWORD;dwShareMode:LONGWORD;
                                   CONST lpSecurityAttributes:SECURITY_ATTRIBUTES;
                                   dwFlags:LONGWORD;VAR lpScreenBufferData):HANDLE;
             APIENTRY;  'KERNEL32' name 'CreateConsoleScreenBuffer';}
FUNCTION GetConsoleCP:LONGWORD;
             APIENTRY;  'KERNEL32' name 'GetConsoleCP';
FUNCTION SetConsoleCP(wCodePageID:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleCP';
FUNCTION GetConsoleOutputCP:LONGWORD;
             APIENTRY;  'KERNEL32' name 'GetConsoleOutputCP';
FUNCTION SetConsoleOutputCP(wCodePageID:LONGWORD):BOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleOutputCP';
END;

IMPLEMENTATION

BEGIN
END.