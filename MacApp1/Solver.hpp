//
//  Solver.hpp
//  MacApp1
//
//  Created by Phuc Nguyen on 4/12/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#ifndef Solver_hpp
#define Solver_hpp

#include <stdio.h>

#include <iostream>
#include <sstream>
#include <iomanip>
#include <algorithm>
#include <vector>
#include <time.h>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
const unsigned int LEN = 4;

//--------------------------------------------------------------------------------------------------
class CowsAndBulls_Player
{
public:
    CowsAndBulls_Player();
    void play();
    string guessANum(string prev, pair<int, int>& r);
    string gimmeANumber();
private:
    void guess();
    
    void clearPool( string gs, pair<int, int>& r );
    

    
    void fillPool();
    
    bool checkIt( string s );
    
    bool removeIt( string gs, string ts, pair<int, int>& res );
    
    bool scoreIt( string gs, pair<int, int>& res );
    
    void getScore( string gs, string st, pair<int, int>& pr );
    
    string createSecret();
    
    string secret;
    vector<string> pool;
};


#endif /* Solver_hpp */
