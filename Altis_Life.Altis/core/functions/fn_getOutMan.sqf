/*
    File: fn_getOutMan.sqf
    Author: blackfisch

    Description:
    handles player leaving vehicle
*/
params [
    ["_unit", objNull, [objNull]],
    ["_role", "", [""]],
    ["_vehicle", objNull, [objNull]],
    ["_turret", [], [[]]]
];

//update view distance settings
[] call life_fnc_updateViewDistance;
