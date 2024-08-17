// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "./Hero.sol";

contract Mage is Hero(50) {
    function attack(address _enemy) public override {
        Enemy enemy = Enemy(_enemy);
        enemy.takeAttack(AttackTypes.Spell);
        super.attack(_enemy); //Or Hero.attack()
    }
}

contract Warrior is Hero(200) {
    function attack(address _enemy) public override {
        Enemy enemy = Enemy(_enemy);
        enemy.takeAttack(AttackTypes.Brawl);
        super.attack(_enemy); //Or Hero.attack()
    }
}
