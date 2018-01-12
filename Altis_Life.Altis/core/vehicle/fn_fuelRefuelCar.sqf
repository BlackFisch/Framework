#include "..\..\script_macros.hpp"
/*
    File: fn_fuelRefuelCar.sqf
    Author: NiiRoZz

    Description:
    Adds fuel in car.
*/
disableSerialization;
private _classname = lbData[20302,(lbCurSel 20302)];
private _index =  lbValue[20302,(lbCurSel 20302)];

if (isNil "_classname" || {_classname isEqualTo ""}) exitWith {
    hint localize "STR_Select_Vehicle_Pump";
    vehiclefuelList = [];
    life_action_inUse = false;
    closeDialog 0;
};

private _car = (vehiclefuelList select _index) select 0;
private _vehicleInfo = [_className] call life_fnc_fetchVehInfo;
private _fuelNow = fuel _car;
private _fueltank = (_vehicleInfo select 12);
if (_car isKindOf "Truck_01_base_F") then {_fueltank = 350}; //vehicles of type "HEMTT"
if (_car isKindOf "Van_01_base_F") then {_fueltank = 100}; //vehicles of type "Van"
if (_car isKindOf "Truck_02_base_F") then {_fueltank = 175}; //vehicles of type "Zamak"
private _fueltoput= ((SliderPosition 20901) - (floor(_fuelnow * _fueltank)));
private _setfuel = _fuelnow + (_fueltoput/_fueltank);
private _timer = ((_fueltoput * .25)/100);
if (_car distance player > 10 && !(isNull objectParent player)) exitWith {
    hint localize "STR_Distance_Vehicle_Pump";
    vehiclefuelList = [];
    life_action_inUse = false;
    closeDialog 0;
};

if ((BANK - (_fueltoput * life_fuelPrices))> 0)then {
    life_is_processing = true;
    //Setup our progress bar.
    disableSerialization;
    "progressBar" cutRsc ["life_progress","PLAIN"];
    private _ui = uiNameSpace getVariable "life_progress";
    private _progress = _ui displayCtrl 38201;
    private _pgText = _ui displayCtrl 38202;
    _pgText ctrlSetText format ["%2 (1%1)...","%","Refuel:"];
    _progress progressSetPosition 0.01;
    private _cP = 0.01;
    private _totalcost = _fueltoput * life_fuelPrices;
    private _stepcost = floor(0.01 * _totalcost);
    for "_i" from 0 to 1 step 0 do {
        uiSleep  _timer;
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%","Refuel:"];
        if (_cP >= 1) exitWith {};
        if (player distance _car > 10) exitWith {};
        if !(isNull objectParent player) exitWith {};
        if !((BANK - _stepcost) > 0) exitWith {};
        BANK = BANK - _stepcost;
        if (((_cP * 100) mod 10) isEqualTo 0) then {
            [_car,_cP * _setfuel] remoteExecCall ["life_fnc_setFuel",_car];
        };
    };
    private _diff = ceil(_totalcost - (100 * _stepcost))); //diffenrence between paid money and calculated price
    BANK = BANK - _diff; //subtract the rest of the price
    "progressBar" cutText ["","PLAIN"];
    if (_car distance player > 10 || {!(isNull objectParent player)}) then {
        hint localize "STR_Distance_Vehicle_Pump";
        vehiclefuelList = [];
        life_is_processing = false;
        life_action_inUse = false;
        [0] call SOCK_fnc_updatePartial;
        closeDialog 0;
    } else {
        life_is_processing = false;
        [0] call SOCK_fnc_updatePartial;
    };
} else {
    hint localize "STR_NOTF_NotEnoughMoney";
};

vehiclefuelList = [];
life_action_inUse = false;
closeDialog 0;
