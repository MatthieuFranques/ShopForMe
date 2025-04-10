import React, {CSSProperties, useEffect, useState} from "react";
import {Tooltip} from "@mui/material";
import {Cell, PlanType} from "../Shop/SingleShop";
import "../Shop/form.scss"
import "./demo.scss"

import {ReactComponent as Play} from "../../images/play.svg";
import {ReactComponent as Pause} from "../../images/pause.svg";
import {ReactComponent as Down} from "../../images/arrow-down.svg";
import {ReactComponent as Up} from "../../images/arrow-up.svg";

interface Position {
    row: number;
    col: number;
}

export default function Demo() {

    const [plan, setPlan] = useState<Array<Array<Cell>>>([
        [
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Légume",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": true
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Fruit",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Viande",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "size": 0,
                "type": PlanType.RAYON,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": "Poisson",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Boulangerie",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "type": PlanType.RAYON,
                "isBeacon": false,
                "size": 0
            },
            {
                "name": "Entretient",
                "type": PlanType.RAYON,
                "isBeacon": false,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "Produit laitier",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Condiment",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": true
            },
            {
                "name": "Condiment",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Condiment",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Condiment",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "name": "Cosmétique",
                "type": PlanType.RAYON,
                "size": 0,
                "isBeacon": false
            },
            {
                "name": "Entretient",
                "type": PlanType.RAYON,
                "isBeacon": true,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": "X",
                "size": 0,
                "type": PlanType.VIDE,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.VIDE,
                "name": "X",
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ],
        [
            {
                "name": PlanType.PLEIN,
                "size": 0,
                "type": PlanType.PLEIN,
                "isBeacon": false
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            },
            {
                "isBeacon": false,
                "type": PlanType.PLEIN,
                "name": PlanType.PLEIN,
                "size": 0
            }
        ]
    ]);

    const [personPosition, setPersonPosition] = useState<Position>({row: 0, col: 0});
    const [destPosition, setDestPosition] = useState<Position>({row: 0, col: 0});
    const [chemin, setChemin] = useState<Array<Array<number>>>([]);

    const [isPaused, setIsPaused] = useState(false);

    const [refreshTime, setRefreshTime] = useState(10);

    const [showControls, setShowControls] = useState(true);

    useEffect(() => {
        if (!isPaused) {
            const intervalId = setInterval(() => {
                const headers = {
                    'Content-Type': 'application/json',
                    'Accept': "*",
                    'Authorization': 'Bearer RKValzAZ8vrVuLV4gXADxkHkqw689gLhBPJSQMa45HzqHCAWu9XizTaE0IBQo6a9'
                };

                fetch("https://0nhxhb9ul5.execute-api.eu-west-1.amazonaws.com/deploy", {
                    method: 'GET',
                    headers: headers
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`Erreur HTTP ! statut : ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(tmp => {

                        const data: any = tmp.shortestPath;

                        setPersonPosition({
                            row: data[0][0],
                            col: data[0][1],
                        })

                        setDestPosition({
                            row: data[data.length - 1][0],
                            col: data[data.length - 1][1],
                        })

                        setChemin(data.slice(1, data.length - 1))

                        console.log('Données reçues :', );
                    })
                    .catch(error => {
                        console.error('Erreur lors de la requête :', error);
                    });

                // const data = [
                //     [3, 4],
                //     [3, 5],
                //     [3, 6],
                //     [4, 6],
                //     [5, 6],
                //     [6, 6],
                //     [6, 7],
                //     [6, 8],
                //     [6, 9],
                //     [7, 9],
                //     [8, 9],
                //     [8, 10],
                //     [8, 11],
                //     [9, 11],
                //     [10, 11],
                //     [10, 12],
                //     [10, 13],
                //     [10, 14],
                //     [11, 14],
                //     [12, 14],
                //     [12, 15],
                //     [12, 16],
                //     [13, 16],
                //     [14, 16],
                //     [14, 17],
                //     [14, 18],
                //     [15, 18]
                // ]



                // fetch("URL_DE_VOTRE_ROUTE_BACKEND") // Remplacez par l'URL de votre backend
                //     .then((response) => response.json())
                //     .then((data) => {
                //         setPersonPosition({ row: data.row, col: data.col });
                //     })
                //     .catch((error) => {
                //         console.error("Erreur lors de la récupération de la position :", error);
                //     });
            }, refreshTime * 1000);

            return () => clearInterval(intervalId);
        }
    }, [isPaused, refreshTime]);

    const getTitleTooltip = (item: Cell, row: number, col: number) => {
        let tmp = item.type === PlanType.RAYON ? item.name : ""
        return `${col}x${row} ` + tmp + (item.isBeacon ? " + beacon" : "")
    }

    /**
     * Generates a CSS class string for a specific cell within a grid.
     *
     * The class string is based on the properties of the cell located at the specified
     * row and column indices within the plan array. The class string will always start
     * with 'cell', followed by the value of the 'name' property of the cell. If the
     * cell's 'isBeacon' property is true, the class string will also include 'BEACON'.
     *
     * @param {number} rowIndex - The index of the row in the plan array.
     * @param {number} colIndex - The index of the column in the plan array.
     * @returns {string} The CSS class string for the specified cell.
     */
    const getCellClass = (rowIndex: number, colIndex: number) => {

        const classes = ["cell", plan[rowIndex][colIndex].name]

        // Ajoute la classe pour indiquer la position de la personne si c'est la cellule concernée
        if (personPosition && personPosition.row === rowIndex && personPosition.col === colIndex) {
            classes.push("person same");
        }

        // Ajoute la classe pour indiquer la position de la destination si c'est la cellule concernée
        if (destPosition && destPosition.row === rowIndex && destPosition.col === colIndex) {
            classes.push("dest same");
        }

        // Vérifie si la cellule est sur le chemin
        const isOnPath: boolean = chemin.some((position: Array<number>) => position[0] === rowIndex && position[1] === colIndex);
        if (isOnPath) {
            classes.push("path same");
        }

        classes.push(plan[rowIndex][colIndex].isBeacon ? "BEACON" : "");
        classes.push(plan[rowIndex][colIndex].type === PlanType.PLEIN ? "pleinItem" : "");

        return classes.join(" ");
    }

    const getStyleRayon = (cell: Cell): CSSProperties => {
        if (cell.type === PlanType.RAYON) {
            const color = localStorage.getItem(cell.name);
            return {backgroundColor: color ? color : "#000000"}
        } else {
            return {}
        }
    }

    return (
        <div className={"demo-container"}>
            <div className="controls">
                <div className="control-toggle">
                    <button className={"customButton controlBtn"} onClick={() => setShowControls((prev) => !prev)}>
                        {showControls ? <Down className="controlBtnIcon"/> : <Up className="controlBtnIcon"/>}
                        {showControls ? "Cacher les contrôles" : "Afficher les contrôles"}
                    </button>
                </div>
                {showControls && (<div>
                    <div>
                        <h2>Lecture</h2>
                        <button className="customButton controlBtn" onClick={() => setIsPaused((prev) => !prev)}>
                            {isPaused ? <Play className="controlBtnIcon"/> : <Pause className="controlBtnIcon"/>}
                            {isPaused ? "Reprendre" : "Pause"}
                        </button>
                    </div>
                    <div className="manual-position">
                        <h2>Position</h2>
                        <div className="positionControl">
                            <label>
                                Ligne :
                                <input
                                    type="number"
                                    value={personPosition.row}
                                    min={0}
                                    max={plan.length - 1}
                                    onChange={(e) => {
                                        const newRow = Number(e.target.value);
                                        if (newRow >= 0 && newRow < plan.length) {
                                            setPersonPosition({...personPosition, row: newRow});
                                        }
                                    }}
                                />
                            </label>
                            <label>
                                Colonne :
                                <input
                                    type="number"
                                    value={personPosition.col}
                                    min={0}
                                    max={plan[0].length - 1}
                                    onChange={(e) => {
                                        const newCol = Number(e.target.value);
                                        if (newCol >= 0 && newCol < plan[0].length) {
                                            setPersonPosition({...personPosition, col: newCol});
                                        }
                                    }}
                                />
                            </label>
                        </div>
                    </div>
                    <div>
                        <h2>Taux de rafraîchissement</h2>
                        <label>
                            Temps :
                            <input
                                type="number"
                                value={refreshTime}
                                min={0}
                                onChange={(e) => {
                                    const refresh = Number(e.target.value);
                                    setRefreshTime(refresh >= 0 ? refresh : 1);
                                }}
                            />
                        </label>
                    </div>
                </div>)}
            </div>

            <table className={"plan"}>
                <tbody>
                {plan.map((row: Array<Cell>, rowIndex: any) => {
                    return (
                        <tr key={rowIndex}>
                            {row.map((col: Cell, colIndex) => (
                                <Tooltip title={getTitleTooltip(col, rowIndex, colIndex)} key={colIndex}
                                         placement={"top"}>
                                    <td className={getCellClass(rowIndex, colIndex)} style={getStyleRayon(col)}>
                                        <div className={"select"}/>
                                    </td>
                                </Tooltip>
                            ))}
                        </tr>
                    );
                })}
                </tbody>
            </table>
        </div>
    )
}