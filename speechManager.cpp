#include "speechManager.h"

//构造函数
SpeechManager::SpeechManager(){};
//菜单功能
void SpeechManager::show_Menu(){
    cout << "****************************" << endl;
    cout << "*********  演讲比赛管理系统  *********" << endl;
    cout << "*********  1.开始演讲比赛  *********" << endl;
    cout << "*********  2.查看比赛记录  *********" << endl;
    cout << "*********  3.清空比赛记录  *********" << endl;
    cout << "*********  0.退出管理系统  *********" << endl;
    cout << "****************************" << endl;
    cout << endl;
}

//析构函数
SpeechManager::~SpeechManager(){};