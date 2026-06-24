#pragma once
#include "speaker.h"
#include <iostream>
#include <vector>
#include <map>
using namespace std;

//设计演讲管理类
class SpeechManager
{
public:
    //构造函数
    SpeechManager();
    //展示菜单
    void show_Menu();
    //退出系统
    void exit_System();
    //析构函数
    ~SpeechManager();
    //创建选手
    void createSpeaker();
    //初始化容器和属性
    void initSpeech();
    //保存第一轮比赛选手编号的容器
    vector<int> v1;
    //第一轮晋级容器 6人
    vector<int> v2;
    //胜出的前三名选手编号
    vector<int> vVictory;
    //存放编号以及对应的选手容器
    map<int,Speaker> m_Speaker;
    //存放比赛轮数
    int m_Index;

};