//
//  Solver.cpp
//  MacApp1
//
//  Created by Phuc Nguyen on 4/12/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#include "Solver.hpp"

#include <iostream>
#include <sstream>
#include <iomanip>
#include <algorithm>
#include <vector>
#include <time.h>

//--------------------------------------------------------------------------------------------------
using namespace std;

//--------------------------------------------------------------------------------------------------
CowsAndBulls_Player::CowsAndBulls_Player() {
    srand (time(NULL));
    fillPool();
}
void CowsAndBulls_Player::play() { secret = createSecret(); guess(); }
string CowsAndBulls_Player::guessANum(string prev, pair<int, int>& r) {
    cout<<"Pool size before call clear" << pool.size() << endl;
    clearPool(prev, r);
    string ret = gimmeANumber();
    cout<<"Pool size after get random" << pool.size() << endl;
    return ret;
}
void CowsAndBulls_Player::guess()
{
    pair<int, int> res; int cc = 1;
    cout << endl << " SECRET: " << secret << endl << "==============" << endl;
    cout << "+-----------+---------+--------+\n|   GUESS   |  BULLS  |  COWS  |\n+-----------+---------+--------+\n";
    while( true )
    {
        string gs = gimmeANumber();
        if( gs.empty() ) { cout << endl << "Something went wrong with the scoring..." << endl << "Cannot find an answer!" << endl; return; }
        if( scoreIt( gs, res ) ) { cout << endl << "I found the secret number!" << endl << "It is: " << gs << endl; return; }
        cout << "|    " << gs << "   |  " << setw( 3 ) << res.first << "    |  " << setw( 3 ) << res.second << "   |\n+-----------+---------+--------+\n";
        clearPool( gs, res );
    }
}

void CowsAndBulls_Player::clearPool( string gs, pair<int, int>& r )
{
    cout<<"Pool size before clear" << pool.size() << endl;
    vector<string>::iterator pi = pool.begin();
    while( pi != pool.end() )
    {
        if( removeIt( gs, ( *pi ), r ) ) {
            pi = pool.erase( pi );
        }
        else  pi++;
    }
    cout<<"Pool size after clear" << pool.size() << endl;
    cout<<"Pool size after clear" << pool.size() << endl;
}

string CowsAndBulls_Player::gimmeANumber()
{
    if( pool.empty() ) return "";
    cout<<"Pool size when get random" << pool.size() << endl;
    return pool[rand() % pool.size()];
}

void CowsAndBulls_Player::fillPool()
{
    for( int x = 1234; x < 9877; x++ )
    {
        ostringstream oss; oss << x;
        if( checkIt( oss.str() ) ) pool.push_back( oss.str() );
    }
}

bool CowsAndBulls_Player::checkIt( string s )
{
    for( string::iterator si = s.begin(); si != s.end(); si++ )
    {
        if( ( *si ) == '0' ) return false;
        if( count( s.begin(), s.end(), ( *si ) ) > 1 ) return false;
    }
    return true;
}

bool CowsAndBulls_Player::removeIt( string gs, string ts, pair<int, int>& res )
{
    pair<int, int> tp; getScore( gs, ts, tp );
    return tp != res;
}

bool CowsAndBulls_Player::scoreIt( string gs, pair<int, int>& res )
{
    getScore( gs, secret, res );
    return res.first == LEN;
}

void CowsAndBulls_Player::getScore( string gs, string st, pair<int, int>& pr )
{
    pr.first = pr.second = 0;
    for( unsigned int ui = 0; ui < LEN; ui++ )
    {
        if( gs[ui] == st[ui] ) pr.first++;
        else
        {
            for( unsigned int vi = 0; vi < LEN; vi++ )
                if( gs[ui] == st[vi] ) pr.second++;
        }
    }
}

string CowsAndBulls_Player::createSecret()
{
    string n = "123456789", rs = "";
    while( rs.length() < LEN )
    {
        int r = rand() % n.length();
        rs += n[r]; n.erase( r, 1 );
    }
    return rs;
}
