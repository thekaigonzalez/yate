/*Copyright 2019-2023 Kai D. Gonzalez*/

import deimos.curses;
import std.stdio : writefln, File;

void export_text(string[] lines)
{
    auto file = File("export.txt", "w");
    for (int i = 0; i < lines.length; i++)
    {
        file.writeln(lines[i]);
    }
    file.close();
}

int main()
{
    string[] lines;
    string line;
    initscr();
    keypad(stdscr, TRUE);

    int cursor_x = 0;
    int cursor_y = 0;

    int exit_code = 0;

    while (true)
    {
        chtype n = getch();

        if (n == KEY_EOL)
        {
        exit:
            endwin();
            break;
        }
        else if (n == '/' && exit_code == 0)
        {
            exit_code = 1;
        }
        else if (n == '/' && exit_code == 1)
        {
            goto exit;
        }
        else if (n == KEY_UP)
        {
            cursor_y--;
        }
        else if (n == KEY_DOWN)
        {
            cursor_y++;
            cursor_x = 0;
        }
        else if (n == KEY_LEFT)
        {
            cursor_x--;
        }
        else
        {
            if (n == KEY_BACKSPACE)
            {
                cursor_x--;
                line = line[0 .. line.length - 1];
            }
            else if (n == 10)
            {
                cursor_x = 0;
                cursor_y++;
                lines ~= line;
                line = "";
            }
            else
            {
                cursor_x++;
                line ~= n;
            }
        }

        if (cursor_x < 0)
        {
            cursor_x = 0;
        }

        if (cursor_y < 0)
        {
            cursor_y = 0;
        }
        move(cursor_y, cursor_x);
        refresh();
    }
    endwin();

    if (line.length > 0)
    {
        lines ~= line;
    }

    export_text(lines);
    return 0;
}
