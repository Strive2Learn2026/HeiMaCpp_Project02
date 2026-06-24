#include "speechManager.h"
#include <windows.h>
using namespace std;

int main()
{
    //创建管理类对象
    SpeechManager sm;

    //测试12名选手调用
    for(const auto&x : sm.m_Speaker)
    {
        std::cout << "编号："<< x.first << "  " <<
         "姓名：" << x.second.m_Name << "  " << 
         "得分：" << x.second.m_Score[0] << std::endl;
    }

    int choice = 0;
    while (true){
        sm.show_Menu();
        cout << "请输入您的选择: ";
        cin >> choice;
        switch (choice)
        {
            case 1:break;
            case 2:break;
            case 3:break;
            case 0:sm.exit_System();break;
            default:system("cls");break;
        }
    }
}