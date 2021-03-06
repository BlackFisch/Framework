/*
    File: fn_wantedRemove.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Removes a person from the wanted list.
*/

params [
    ["_uid", "", [""]]
];

if (_uid isEqualTo "") exitWith {}; //Bad data

private _query = format ["deleteWanted:%1", _uid];
[_query, 2] call HC_fnc_asyncCall;
