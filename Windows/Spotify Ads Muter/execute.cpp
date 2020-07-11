#include <iostream>
#include <windows.h>
using namespace std;

BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam);

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR pCmdLine, int iCmdShow)
{
	EnumWindows(EnumWindowsProc, NULL);
	return 0;
}


BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam)
{
	char title[80];
	GetWindowText(hwnd,title,sizeof(title));
	string windows = title;
	cout << windows;
	return TRUE;
}

