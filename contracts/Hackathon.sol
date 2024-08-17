// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Hackathon {
    struct Project {
        string title;
        uint[] ratings;
    }

    Project[] public projects;

    // Create a new project
    function newProject(string memory _title) external {
        projects.push(Project({title: _title, ratings: new uint[](0)}));
    }

    // Rate a project by index
    function rate(uint _projectIndex, uint _rating) external {
        require(_projectIndex < projects.length, "Invalid project index");

        projects[_projectIndex].ratings.push(_rating);
    }

    // Calculate the average of ratings for a given project
    function findAverage(uint[] storage _ratings) internal view returns (uint) {
        uint total = 0;
        if (_ratings.length == 0) {
            return 0; // Avoid division by zero
        }

        for (uint i = 0; i < _ratings.length; i++) {
            total += _ratings[i];
        }

        return total / _ratings.length;
    }

    // Find and return the winning project based on the highest average rating
    function findWinner() external view returns (Project memory) {
        uint highestRating = 0;
        uint winningIndex = 0;

        for (uint i = 0; i < projects.length; i++) {
            uint averageRating = findAverage(projects[i].ratings);

            if (averageRating > highestRating) {
                highestRating = averageRating;
                winningIndex = i;
            }
        }

        return projects[winningIndex];
    }
}
