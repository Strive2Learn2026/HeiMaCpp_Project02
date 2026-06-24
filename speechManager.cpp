#include "speechManager.h"
#include "speaker.h"
#include <cstdlib>

//构造函数
SpeechManager::SpeechManager()
{
    this->initSpeech();
    this->createSpeaker();
};
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
//退出功能
void SpeechManager::exit_System()
{
    cout << " 欢迎下次使用！ "<< endl;
    system("pause");
    exit(0);
}
void SpeechManager::createSpeaker()
{
    string nameSeed = "ABCDEFGHIJKL";
    for(int i = 0;i<nameSeed.size();++i)
    {
        string name = "选手";
        name += nameSeed[i];
        Speaker sp;
        sp.m_Name = name;
        for(int j = 0; j < 2;++j)
        {
            sp.m_Score[j] = 0.0;
        }
        //创建选手编号，并且放入V1容器中
        this->v1.push_back(i + 10001);
        //选手编号以及对应选手放入到map容器中
        m_Speaker.insert({i+10001,sp});
    }
}

//初始化容器和属性
void SpeechManager::initSpeech()
{
    //容器都直控
    this->v1.clear();
    this->v2.clear();
    this->vVictory.clear();
    this->m_Speaker.clear();

    //初始化比赛轮数
    this->m_Index = 1;

}

//析构函数
SpeechManager::~SpeechManager(){};