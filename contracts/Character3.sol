// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Character3 {
    //YATTATCHI
    using Strings for uint256;

    string[10] public colorNames = [
        "FFFFFF",
        "FF0000",
        "008000",
        "0000FF",
        "FFFF00",
        "00FFFF",
        "800000",
        "808000",
        "800080",
        "808080"
    ];

    function generateRandomNumber(
        uint256 prevEntropy
    ) public view returns (uint256) {
        uint256 randomNumber = uint256(
            keccak256(
                abi.encode(
                    prevEntropy,
                    block.timestamp,
                    block.prevrandao,
                    blockhash(block.number - 1)
                )
            )
        );
        return uint256(randomNumber % 10);
    }

    function generateCharacter() public view returns (string memory) {
        string[3] memory colors;
        uint256[3] memory previous;
        previous[0] = generateRandomNumber(0);
        colors[0] = colorNames[previous[0]];
        previous[1] = generateRandomNumber(previous[0]);
        colors[1] = colorNames[generateRandomNumber(previous[1])];
        previous[2] = generateRandomNumber(previous[1]);
        colors[2] = colorNames[generateRandomNumber(previous[2])];
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="500px" height="500px" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" xmlns:xlink="http://www.w3.org/1999/xlink">',
            "<g>",
            '<path style="opacity:0.944" fill="#074d86" d="M 356.5,3.5 C 358.17,3.75115 359.67,4.41782 361,5.5C 363.415,12.25 365.915,18.9166 368.5,25.5C 374.464,27.4324 380.464,29.2658 386.5,31C 390.615,34.6005 390.281,37.9339 385.5,41C 381,44.1667 376.5,47.3333 372,50.5C 371.273,56.6936 371.439,62.8603 372.5,69C 372.08,73.3749 369.747,75.0415 365.5,74C 361.361,71.3609 357.361,68.5276 353.5,65.5C 342.163,86.8355 324.496,96.0022 300.5,93C 285.334,87.5655 270.667,88.5655 256.5,96C 250.063,100.617 245.73,106.784 243.5,114.5C 299.573,112.604 341.073,135.938 368,184.5C 382.043,209.338 389.876,236.005 391.5,264.5C 400.777,263.062 410.111,262.062 419.5,261.5C 436.296,260.818 450.13,266.818 461,279.5C 467.869,289.137 469.202,299.47 465,310.5C 462.188,314.662 458.355,317.495 453.5,319C 448.146,319.529 442.813,319.362 437.5,318.5C 435.544,335.652 426.544,340.652 410.5,333.5C 406.446,340.2 400.446,343.867 392.5,344.5C 394.209,350.376 397.876,354.543 403.5,357C 413.087,359.154 422.754,360.654 432.5,361.5C 435.312,367.027 434.812,372.36 431,377.5C 421.17,391.175 408.003,400.008 391.5,404C 385.5,407.333 379.5,410.667 373.5,414C 365.013,416.072 357.013,414.739 349.5,410C 346.167,409.333 342.833,409.333 339.5,410C 330.833,415 322.167,420 313.5,425C 307.003,428.039 300.336,428.706 293.5,427C 288.833,424.333 284.167,421.667 279.5,419C 271.645,416.939 264.312,418.272 257.5,423C 251.167,427.333 244.833,431.667 238.5,436C 232.135,439.703 225.468,440.37 218.5,438C 212.809,434.487 207.476,430.487 202.5,426C 197.652,423.211 192.652,422.878 187.5,425C 180.658,428.922 173.658,432.588 166.5,436C 160.338,438.264 154.004,438.93 147.5,438C 142.272,435.503 139.939,431.337 140.5,425.5C 141.434,418.263 142.767,411.097 144.5,404C 141.473,389.108 135.806,375.275 127.5,362.5C 119.272,370.521 110.272,371.521 100.5,365.5C 96.0627,370.435 90.5627,373.435 84,374.5C 76.0228,373.189 71.3561,368.523 70,360.5C 59.2134,370.708 48.2134,371.041 37,361.5C 29.4921,347.534 30.1588,333.868 39,320.5C 49.0599,309.049 61.5599,301.549 76.5,298C 86.9875,295.069 97.6541,293.236 108.5,292.5C 104.887,257.288 109.721,223.288 123,190.5C 141.789,156.054 169.956,132.888 207.5,121C 216.069,118.628 224.736,116.795 233.5,115.5C 239.902,92.2807 255.235,80.6141 279.5,80.5C 287.255,81.0943 294.921,82.261 302.5,84C 319.955,86.2719 333.288,79.9386 342.5,65C 338.298,66.2272 333.964,67.3939 329.5,68.5C 326.458,68.5755 324.791,67.0755 324.5,64C 326.693,57.7529 328.693,51.4195 330.5,45C 327.449,39.5997 323.949,34.4331 320,29.5C 317.983,26.8728 318.15,24.3728 320.5,22C 327.833,21.6667 335.167,21.3333 342.5,21C 346.836,14.7839 351.503,8.95057 356.5,3.5 Z" />',
            "</g>",
            '<g fill="#',
            colors[0],
            '">',
            '<path style="opacity:1" d="M 355.5,18.5 C 357.662,22.1402 359.162,26.1402 360,30.5C 360.833,31.3333 361.667,32.1667 362.5,33C 366.489,34.3314 370.489,35.6647 374.5,37C 371,39.8333 367.5,42.6667 364,45.5C 363.667,50.8333 363.333,56.1667 363,61.5C 358.998,58.0009 354.665,55.0009 350,52.5C 345.493,53.779 341.16,55.4457 337,57.5C 337.621,52.7827 338.788,48.116 340.5,43.5C 338.222,39.1176 335.556,34.9509 332.5,31C 337.5,30.6667 342.5,30.3333 347.5,30C 350.3,26.2249 352.966,22.3916 355.5,18.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#c5bfde" d="M 238.5,123.5 C 264.267,122.849 288.933,127.683 312.5,138C 325.833,145.994 337.333,156.16 347,168.5C 370.45,200.178 382.783,235.845 384,275.5C 384.603,295.19 384.103,314.857 382.5,334.5C 382.061,349.2 388.394,359.7 401.5,366C 409.218,367.286 416.884,368.786 424.5,370.5C 415.999,383.164 404.332,391.331 389.5,395C 382.579,398.265 375.913,401.932 369.5,406C 362.814,405.999 356.481,404.332 350.5,401C 346.5,400.333 342.5,400.333 338.5,401C 328.383,405.558 318.716,410.891 309.5,417C 305.738,419.156 301.738,419.823 297.5,419C 292.398,416.032 287.231,413.199 282,410.5C 274.326,407.811 266.826,408.311 259.5,412C 250.658,416.585 242.325,421.918 234.5,428C 229.994,430.814 225.327,431.147 220.5,429C 214.295,423.126 207.295,418.46 199.5,415C 195.833,414.333 192.167,414.333 188.5,415C 177.888,420.805 166.888,425.805 155.5,430C 150.77,431.604 148.77,429.937 149.5,425C 149.821,420.728 150.654,416.562 152,412.5C 152.667,406.5 152.667,400.5 152,394.5C 145.023,378.54 138.023,362.54 131,346.5C 110.697,296.578 110.364,246.578 130,196.5C 148.518,162.002 176.685,139.169 214.5,128C 222.572,126.157 230.572,124.657 238.5,123.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#104f87" d="M 227.5,163.5 C 266.181,160.002 299.348,171.669 327,198.5C 355.619,236.777 355.619,275.111 327,313.5C 313.887,329.308 297.054,338.141 276.5,340C 258.195,341.536 239.862,341.869 221.5,341C 198.795,338.806 178.461,330.806 160.5,317C 134.651,291.451 128.485,261.617 142,227.5C 158.095,189.57 186.595,168.236 227.5,163.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#fdfada" d="M 230.5,171.5 C 265.692,169.171 295.859,180.171 321,204.5C 345.638,238.78 345.638,273.113 321,307.5C 308.698,322.402 292.865,330.568 273.5,332C 242.548,336.682 212.548,333.349 183.5,322C 144.616,299.346 134.116,267.179 152,225.5C 168.234,193.104 194.401,175.104 230.5,171.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#1d548a" d="M 200.5,191.5 C 207.004,191.138 208.671,193.638 205.5,199C 196.613,203.961 187.447,205.128 178,202.5C 177.08,199.692 177.913,197.525 180.5,196C 185.547,195.662 190.547,194.995 195.5,194C 197.491,193.626 199.158,192.793 200.5,191.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#1d548a" d="M 270.5,191.5 C 278.762,194.119 287.262,195.785 296,196.5C 300.073,201.965 298.573,204.632 291.5,204.5C 283.195,204.552 275.695,202.219 269,197.5C 268.252,195.16 268.752,193.16 270.5,191.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#0d4e87" d="M 187.5,212.5 C 204.654,210.658 217.154,217.324 225,232.5C 226.033,245.925 221.866,257.425 212.5,267C 209.661,268.92 206.661,270.587 203.5,272C 186.552,276.109 174.718,270.275 168,254.5C 165.118,235.94 171.618,221.94 187.5,212.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#0f4f87" d="M 283.5,212.5 C 299.224,212.105 310.724,218.772 318,232.5C 319.397,246.309 315.231,258.142 305.5,268C 291.429,276.27 278.262,275.103 266,264.5C 256.61,246.546 259.443,230.712 274.5,217C 277.592,215.454 280.592,213.954 283.5,212.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#fafbfc" d="M 189.5,220.5 C 205.935,219.072 210.768,225.739 204,240.5C 199.261,246.082 193.761,246.915 187.5,243C 180.299,234.657 180.966,227.157 189.5,220.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#fbfcfd" d="M 278.5,220.5 C 293.784,218.266 298.95,224.266 294,238.5C 290.259,245.423 284.759,247.256 277.5,244C 269.196,235.583 269.529,227.749 278.5,220.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#fbfbfd" d="M 198.5,251.5 C 206.748,250.632 209.915,254.298 208,262.5C 205.947,266.292 202.781,267.458 198.5,266C 194.547,261.169 194.547,256.335 198.5,251.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#fafbfc" d="M 287.5,251.5 C 293.875,250.049 297.208,252.549 297.5,259C 297.741,263.926 295.407,266.426 290.5,266.5C 288.088,266.594 286.255,265.594 285,263.5C 283.773,258.938 284.607,254.938 287.5,251.5 Z" />',
            "</g>",
            '<g fill="#',
            colors[1],
            '">',
            '<path style="opacity:1" d="M 407.5,270.5 C 420.885,268.899 433.552,271.065 445.5,277C 455.197,283.228 459.364,292.061 458,303.5C 456.326,308.843 452.66,311.176 447,310.5C 439.317,309.742 432.483,306.909 426.5,302C 421.41,301.171 419.576,303.338 421,308.5C 428.86,313.172 430.36,319.339 425.5,327C 418.218,328.016 412.218,325.683 407.5,320C 405.5,319.333 403.5,319.333 401.5,320C 400.813,323.766 400.646,327.599 401,331.5C 398.016,334.1 394.516,335.1 390.5,334.5C 392.149,314.206 392.816,293.872 392.5,273.5C 397.647,272.604 402.647,271.604 407.5,270.5 Z" />',
            '<path style="opacity:1" d="M 99.5,301.5 C 103.167,301.5 106.833,301.5 110.5,301.5C 112.63,317.685 116.797,333.352 123,348.5C 122.196,359.231 116.863,362.564 107,358.5C 108.193,352.036 105.693,349.203 99.5,350C 96.3318,357.001 91.3318,362.167 84.5,365.5C 81.0122,364.508 79.1789,362.175 79,358.5C 78.154,353.944 78.654,349.611 80.5,345.5C 80.0194,340.618 77.6861,339.451 73.5,342C 69.1705,351.321 62.0038,357.487 52,360.5C 47.5071,359.346 44.1738,356.679 42,352.5C 38.3885,337.005 43.2218,324.838 56.5,316C 70.1726,308.832 84.506,303.998 99.5,301.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#185289" d="M 240.5,279.5 C 248.093,281.879 254.593,286.213 260,292.5C 261.316,296.128 260.149,298.461 256.5,299.5C 252.13,295.96 247.63,292.626 243,289.5C 238.932,292.119 234.766,294.619 230.5,297C 225.504,297.664 223.67,295.498 225,290.5C 230.625,287.359 235.792,283.692 240.5,279.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#0d4f87" d="M 198.5,343.5 C 201.044,343.104 203.211,343.771 205,345.5C 206.175,351.865 207.508,358.199 209,364.5C 209.667,370.5 209.667,376.5 209,382.5C 207.347,386.482 204.347,388.482 200,388.5C 192.645,386.16 186.645,381.826 182,375.5C 177.468,369.773 173.968,363.44 171.5,356.5C 172.486,352.853 174.819,351.686 178.5,353C 182.565,362.731 188.565,371.065 196.5,378C 198.025,379.009 199.692,379.509 201.5,379.5C 201.147,369.199 199.814,359.032 197.5,349C 197.581,347.076 197.914,345.243 198.5,343.5 Z" />',
            "</g>",
            "<g>",
            '<path style="opacity:1" fill="#0f4f88" d="M 304.5,343.5 C 308.198,342.68 310.531,344.013 311.5,347.5C 307.669,355.828 303.836,364.162 300,372.5C 298.051,383.885 301.884,386.385 311.5,380C 318.645,373.193 324.645,365.527 329.5,357C 331.5,356.333 333.5,356.333 335.5,357C 336.081,357.893 336.415,358.893 336.5,360C 332.155,370.028 325.821,378.694 317.5,386C 312.062,390.921 305.729,392.588 298.5,391C 293.297,388.267 290.631,383.933 290.5,378C 290.908,373.292 292.074,368.792 294,364.5C 297.529,357.442 301.029,350.442 304.5,343.5 Z" />',
            "</g>",
            '<g fill="#',
            colors[2],
            '">',
            '<path style="opacity:0.968" d="M 236.5,464.5 C 255.503,464.333 274.503,464.5 293.5,465C 309.512,465.716 325.178,468.382 340.5,473C 344.475,473.967 347.142,476.3 348.5,480C 348.097,481.473 347.43,482.806 346.5,484C 333.142,489.873 319.142,493.206 304.5,494C 270.707,496.739 237.04,495.739 203.5,491C 195.508,490.053 188.342,487.22 182,482.5C 181.267,477.537 183.433,474.37 188.5,473C 204.33,468.434 220.33,465.6 236.5,464.5 Z" />',
            "</g>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }
}
