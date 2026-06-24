#include "speechManager.h"
#include <windows.h>
using namespace std;

int main()
{
    //创建管理类对象
    SpeechManager sm;
    int choice = 0;
    while (true){
        sm.show_Menu();
        cout << "请输入您的选择: ";
        cin >> choice;
        switch (choice)
        {
            case 1:
            break;
            case 2:
            break;
            case 3:
            break;
            case 0:
            break;
            default:break;
        }
    //显示菜单
    sm.show_Menu();
    return 0;
    }
}