// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Character2 {
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
            '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="500px" height="500px" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" xmlns:xlink="http://www.w3.org/1999/xlink">'
            '<g><path style="opacity:0.954" fill="#124d84" d="M 247.5,57.5 C 252.941,57.2651 257.274,59.2651 260.5,63.5C 274.405,57.11 280.405,61.4434 278.5,76.5C 287.032,77.1884 290.532,81.8551 289,90.5C 288.727,92.3289 287.893,93.8289 286.5,95C 294.363,101.592 294.363,108.258 286.5,115C 277.12,118.625 267.953,118.125 259,113.5C 255.176,120.446 252.009,127.78 249.5,135.5C 291.512,131.763 326.678,145.43 355,176.5C 359.389,181.889 363.389,187.556 367,193.5C 374.49,188.853 381.157,189.853 387,196.5C 388.629,192.069 391.129,188.236 394.5,185C 405.227,180.863 411.894,184.363 414.5,195.5C 414.167,196.167 413.833,196.833 413.5,197.5C 416.885,197.312 420.218,198.146 423.5,200C 427.192,204.852 428.192,210.185 426.5,216C 433.715,221.213 435.382,227.879 431.5,236C 432.045,239.187 432.711,242.354 433.5,245.5C 446.709,252.556 454.543,263.556 457,278.5C 461.855,306.93 454.688,331.764 435.5,353C 413.88,370.215 390.213,373.882 364.5,364C 358.658,360.246 352.991,356.246 347.5,352C 343.578,348.749 340.412,344.916 338,340.5C 320.45,358.192 299.283,368.859 274.5,372.5C 278.421,382.425 282.255,392.425 286,402.5C 291.219,419.895 285.385,431.729 268.5,438C 250.259,442.306 231.925,442.639 213.5,439C 205.084,437.715 198.584,433.548 194,426.5C 192.098,410.388 199.265,401.221 215.5,399C 228.239,398.082 240.572,399.915 252.5,404.5C 252.833,404.167 253.167,403.833 253.5,403.5C 251.303,396.077 248.803,388.744 246,381.5C 245.505,379.527 245.338,377.527 245.5,375.5C 218.904,375.776 196.07,366.776 177,348.5C 168.512,356.321 160.012,364.154 151.5,372C 139.732,377.091 128.399,376.091 117.5,369C 99.0415,356.878 88.3748,339.878 85.5,318C 86.9369,302.447 95.2702,296.447 110.5,300C 117.479,302.641 122.979,307.141 127,313.5C 133.251,322.999 139.251,332.666 145,342.5C 150.533,337.302 155.7,331.802 160.5,326C 151.085,310.177 146.418,293.01 146.5,274.5C 132.351,273.431 119.351,268.931 107.5,261C 97.4618,254.635 88.2952,247.135 80,238.5C 71.9835,227.2 72.8169,216.7 82.5,207C 87.3759,204.264 92.3759,203.93 97.5,206C 115.321,219.247 134.654,229.914 155.5,238C 159.05,238.784 162.55,239.617 166,240.5C 169.682,236.985 173.182,233.318 176.5,229.5C 153.538,223.185 132.204,213.352 112.5,200C 94.4248,185.044 87.9248,166.211 93,143.5C 100.507,129.831 112.007,124.331 127.5,127C 132.373,127.884 137.04,129.384 141.5,131.5C 149.477,116.072 162.31,107.739 180,106.5C 196.162,107.911 208.828,115.244 218,128.5C 221.047,117.358 224.88,106.525 229.5,96C 217.125,88.4143 215.459,79.081 224.5,68C 229.055,66.0483 233.388,66.5483 237.5,69.5C 238.405,63.2771 241.739,59.2771 247.5,57.5 Z"/></g>'
            '<g fill="#',
            colors[0],
            '">'
            '<path style="opacity:1" d="M 247.5,66.5 C 249.144,66.2865 250.644,66.6198 252,67.5C 252.333,71.8333 252.667,76.1667 253,80.5C 254.581,83.5534 256.914,84.22 260,82.5C 260.84,78.9367 262.174,75.6034 264,72.5C 265.87,70.7811 268.037,69.7811 270.5,69.5C 269.614,74.9402 266.947,79.2735 262.5,82.5C 261.098,85.9696 262.264,88.303 266,89.5C 270.597,87.2446 275.43,85.9113 280.5,85.5C 280.657,86.8734 280.49,88.2068 280,89.5C 276.814,92.0039 273.981,94.8373 271.5,98C 272.101,99.605 273.101,100.938 274.5,102C 277.224,102.27 279.891,102.77 282.5,103.5C 283.583,104.365 283.749,105.365 283,106.5C 279.961,107.608 276.794,108.275 273.5,108.5C 268.377,107.071 263.21,105.738 258,104.5C 253.265,104.565 250.265,106.898 249,111.5C 245.47,120.423 242.137,129.423 239,138.5C 234.97,140.456 230.803,142.122 226.5,143.5C 225.34,139.541 225.173,135.541 226,131.5C 228.868,123.228 231.535,114.895 234,106.5C 236.053,102.226 238.219,98.0597 240.5,94C 240.415,92.8926 240.081,91.8926 239.5,91C 235.581,89.4597 232.081,87.2931 229,84.5C 226.87,81.3351 227.037,78.3351 229.5,75.5C 233.167,77.6667 236.833,79.8333 240.5,82C 242.701,82.8249 244.534,82.3249 246,80.5C 246.223,75.7503 246.723,71.0836 247.5,66.5 Z"/>'
            '<path style="opacity:1" d="M 400.5,191.5 C 403.485,191.818 405.152,193.485 405.5,196.5C 404.631,199.941 403.464,203.274 402,206.5C 400.087,212.094 401.92,214.261 407.5,213C 410.941,211.224 414.108,209.057 417,206.5C 418.518,208.614 418.851,210.947 418,213.5C 407.815,224.075 409.982,228.075 424.5,225.5C 424.5,226.833 424.5,228.167 424.5,229.5C 422.143,229.337 419.81,229.503 417.5,230C 414.833,232.667 414.833,235.333 417.5,238C 420.007,238.093 422.174,238.926 424,240.5C 424.711,242.367 424.211,243.867 422.5,245C 412.478,245.486 402.478,246.153 392.5,247C 390.264,250.145 388.764,253.645 388,257.5C 379.196,269.604 370.029,281.438 360.5,293C 351.87,299.961 343.537,307.295 335.5,315C 328.82,320.56 321.154,322.893 312.5,322C 311.833,321.333 311.167,320.667 310.5,320C 320.617,316.525 329.117,310.691 336,302.5C 350.079,282.68 363.413,262.346 376,241.5C 379.439,235.794 381.273,229.627 381.5,223C 381.586,216.338 379.086,210.838 374,206.5C 371.188,201.769 372.355,199.602 377.5,200C 379.833,202.333 382.167,204.667 384.5,207C 386.914,208.885 389.581,209.552 392.5,209C 394.139,205.741 395.306,202.241 396,198.5C 397.012,195.798 398.512,193.465 400.5,191.5 Z"/>'
            "</g>"
            '<g><path style="opacity:1" fill="#e40513" d="M 174.5,115.5 C 187.22,115.238 198.054,119.571 207,128.5C 210.111,132.387 212.444,136.72 214,141.5C 214.755,144.303 214.422,146.97 213,149.5C 205.068,155.428 197.735,162.095 191,169.5C 178.588,157.306 165.254,146.306 151,136.5C 150.875,131.253 153.041,127.087 157.5,124C 162.98,120.593 168.647,117.76 174.5,115.5 Z"/></g>'
            '<g><path style="opacity:1" fill="#e50212" d="M 114.5,135.5 C 124.772,134.985 134.439,137.151 143.5,142C 158.658,151.817 172.658,163.151 185.5,176C 188.508,178.754 192.008,180.587 196,181.5C 200.403,180.412 201.57,177.745 199.5,173.5C 208.188,162.001 219.521,154.167 233.5,150C 271.73,138.312 306.063,145.312 336.5,171C 352.436,184.037 362.936,200.537 368,220.5C 369.145,225.799 369.478,231.132 369,236.5C 356.996,257.182 343.996,277.182 330,296.5C 322.411,305.1 313.077,310.766 302,313.5C 300.473,321.28 303.306,326.78 310.5,330C 315.5,330.667 320.5,330.667 325.5,330C 331.449,328.027 336.783,325.027 341.5,321C 353.604,310.899 365.104,300.065 376,288.5C 381.947,279.553 388.28,270.886 395,262.5C 396.741,259.691 397.908,256.691 398.5,253.5C 408.088,255.115 417.588,254.781 427,252.5C 439.637,258.489 446.97,268.489 449,282.5C 451.7,303.709 447.034,323.042 435,340.5C 420.213,356.081 402.046,362.914 380.5,361C 367.466,356.303 356.3,348.803 347,338.5C 346.414,329.323 342.247,327.156 334.5,332C 314.682,351.906 290.682,363.24 262.5,366C 219.539,371.602 187.372,355.768 166,318.5C 157.189,301.979 154.189,284.646 157,266.5C 155.915,265.707 154.748,265.04 153.5,264.5C 148.283,266.945 142.949,267.111 137.5,265C 118.68,258.496 102.18,248.329 88,234.5C 84.5926,230.372 82.926,225.705 83,220.5C 84.578,215.131 88.078,212.965 93.5,214C 109.009,224.926 125.342,234.593 142.5,243C 151.409,247.23 160.742,248.896 170.5,248C 177.017,242.148 182.85,235.648 188,228.5C 188.92,225.692 188.087,223.525 185.5,222C 181.251,220.874 176.918,220.208 172.5,220C 155.533,213.683 139.199,206.016 123.5,197C 107.033,185.899 99.1994,170.399 100,150.5C 102.351,142.984 107.184,137.984 114.5,135.5 Z"/></g>'
            '<g><path style="opacity:1" fill="#174c83" d="M 229.5,170.5 C 243.441,168.702 248.941,174.702 246,188.5C 242.983,201.252 235.483,205.418 223.5,201C 216.507,193.905 215.673,186.071 221,177.5C 223.628,174.79 226.461,172.456 229.5,170.5 Z"/></g>'
            '<g><path style="opacity:1" fill="#154c83" d="M 297.5,232.5 C 306.26,232.09 311.26,236.256 312.5,245C 310.913,256.417 304.58,263.584 293.5,266.5C 283.716,263.4 280.216,256.734 283,246.5C 286.433,240.231 291.266,235.564 297.5,232.5 Z"/></g>'
            '<g fill="#',
            colors[1],
            '">'
            '<path style="opacity:1" d="M 272.5,279.5 C 292.847,277.355 302.681,286.355 302,306.5C 295.71,323.559 284.21,328.392 267.5,321C 257.643,313.662 254.809,304.162 259,292.5C 262.076,286.589 266.576,282.255 272.5,279.5 Z"/>'
            "</g>"
            '<g><path style="opacity:0.886" fill="#004b85" d="M 71.5,370.5 C 73.9928,370.329 75.8261,371.329 77,373.5C 73.4145,390.119 80.2479,399.453 97.5,401.5C 103.338,400.501 108.838,398.501 114,395.5C 117.668,396.504 119.002,398.837 118,402.5C 103.49,412.935 88.9903,412.769 74.5,402C 66.2866,393.39 64.4533,383.557 69,372.5C 69.9947,371.934 70.828,371.267 71.5,370.5 Z"/></g>'
            '<g fill="#',
            colors[2],
            '">'
            '<path style="opacity:1" d="M 254.5,374.5 C 258.673,373.956 262.506,374.623 266,376.5C 269.667,385.167 273.333,393.833 277,402.5C 278.806,408.865 278.806,415.199 277,421.5C 270.637,428.074 262.804,431.574 253.5,432C 238.971,433.372 224.638,432.372 210.5,429C 199.822,424.612 198.822,418.612 207.5,411C 209.717,409.725 212.051,408.725 214.5,408C 230.182,407.036 245.182,409.869 259.5,416.5C 264.078,415.132 265.578,412.132 264,407.5C 261.77,398.248 258.77,389.248 255,380.5C 254.505,378.527 254.338,376.527 254.5,374.5 Z"/>'
            '<path style="opacity:1" d="M 100.5,307.5 C 107.766,307.575 113.599,310.575 118,316.5C 124.396,325.901 130.396,335.568 136,345.5C 138.167,347.667 140.333,349.833 142.5,352C 143.833,352.667 145.167,352.667 146.5,352C 148.5,350.667 150.5,349.333 152.5,348C 156.315,343.018 160.648,338.518 165.5,334.5C 167.607,336.53 169.607,338.697 171.5,341C 164.833,346.333 158.833,352.333 153.5,359C 150.833,361 148.167,363 145.5,365C 140.167,367 134.833,367 129.5,365C 109.201,355.533 97.5341,339.7 94.5,317.5C 94.4898,312.838 96.4898,309.505 100.5,307.5 Z"/>'
            "</g>"
            '<g><path style="opacity:0.892" fill="#004b85" d="M 44.5,382.5 C 47.3646,382.055 49.8646,382.722 52,384.5C 50.2076,391.351 49.2076,398.351 49,405.5C 55.8465,429.929 70.5132,436.596 93,425.5C 96.9145,426.183 98.2478,428.517 97,432.5C 83.5484,442.567 69.715,443.067 55.5,434C 39.2325,419.494 35.5659,402.328 44.5,382.5 Z"/></g>'
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
