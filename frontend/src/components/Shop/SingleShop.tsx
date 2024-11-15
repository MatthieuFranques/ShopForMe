import React, {CSSProperties, useEffect, useState} from 'react';
import {useNavigate, useParams} from 'react-router-dom';
import "./form.scss"
import {Autocomplete, Button, createFilterOptions, TextField, Tooltip} from "@mui/material";
import {Product} from "../Product/Product";
import {ProductModel} from "../../models/Product.model";
import randomColor from "randomcolor";
import {ShopModel} from "../../models/Shop.model";
import {ShopService} from "../../services/shop.service";
import DeleteIcon from '@mui/icons-material/Delete';
import {ProductService} from "../../services/product.service";

export enum PlanType {
    VIDE = "VIDE",
    RAYON = "RAYON",
    PLEIN = "PLEIN",
    BEACON = "BEACON",
    CHEMIN = "CHEMIN"
}

export interface Cell {
    name: string;
    size?: number;
    type: PlanType;
    isBeacon: boolean;
}
const EMPTY_CELL: Cell = {
    isBeacon: false,
    type: PlanType.VIDE,
    name: "X",
    size: 0
}

const PLEIN_CELL: Cell = {
    isBeacon: false,
    type: PlanType.PLEIN,
    name: "PLEIN",
    size: 0
}

interface CustomProps {
    plan: Array<Array<Cell>>;
    onFinish: (plan: Array<Array<Cell>>) => void;
    isEdit: boolean;
    name: string;
    storeId: number;
}

const Plan = (props: CustomProps) => {

    const [plan, setPlan] = useState<Array<Array<Cell>>>(props.plan);

    const [rows, setRows] = useState<number>(10);

    const [cols, setCols] = useState<number>(10);

    const [currentDraw, setCurrentDraw] = useState<PlanType>(PlanType.VIDE);

    const [value, setValue] = React.useState<string | null>(null);

    const [rayons, setRayons] = useState<string[]>([]);

    const filter = createFilterOptions<string>();

    const handleChangeRadio = (event: any) => {
        setCurrentDraw(event.target.value as PlanType);
    };

    const [info, setInfo] = useState<{ open: boolean, message: string, type: "success" | "error" }>({
        open: false,
        message: "",
        type: "error"
    })

    useEffect(() => {
        if (plan[0]) {
            setCols(plan[0].length)
            setRows(plan.length)
            setRayons(getListRayon());
        } else {
            getNewPlan()
        }
    }, [])

    const getNewPlan = () => {
        const plan = Array.from({length: 10}, (_) => Array.from({length: 10}, (_) => EMPTY_CELL))
        setPlan(plan)
    }

    useEffect(() => {
        if (plan)
            props.onFinish(plan)
    }, [plan])

    const setColorRayons = (nb : number) => {
        const color = randomColor({count: nb});
        rayons.map((r, count) => {
            if (!localStorage.getItem(r))
                localStorage.setItem(r, color[count]);
        })
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

        classes.push(plan[rowIndex][colIndex].isBeacon ? "BEACON" : "");

        return classes.join(" ");
    }

    /**
     * Function to toggle the state of a cell within a given 2D plan based on its row and column indices,
     * and the current drawing type.
     *
     * @param {number} rowIndex - The index of the row where the cell is located.
     * @param {number} colIndex - The index of the column where the cell is located.
     */
    const toggleCell = (rowIndex: number, colIndex: number) => {
        setPlan(prevPlan => {
            const newPlan = [...prevPlan];

            const updatedRow = [...newPlan[rowIndex]];

            switch (currentDraw) {
                case PlanType.BEACON:
                    updatedRow[colIndex] = {
                        ...updatedRow[colIndex],
                        isBeacon: !updatedRow[colIndex].isBeacon
                    };
                    break;
                case PlanType.RAYON:
                    if (value) {
                        updatedRow[colIndex] = {
                            name: value,
                            type: PlanType.RAYON,
                            isBeacon: updatedRow[colIndex].isBeacon
                        };
                    }
                    break;
                case PlanType.PLEIN:
                    updatedRow[colIndex] = PLEIN_CELL;
                    break;
                case PlanType.VIDE:
                    updatedRow[colIndex] = EMPTY_CELL;
                    break;
                default:
                    return prevPlan;
            }

            newPlan[rowIndex] = updatedRow;

            return newPlan;
        });

        // handleRayon(rowIndex, colIndex);

        // if (currentRayonDestination !== "") {
        //     travelToRayon(currentRayonDestination);
        // }
    }

    const getListDrawType = () => {
        return Object.values(PlanType).filter((type) => type !== PlanType.CHEMIN);
    }

    /**
     * Retrieves a unique list of rayon names from a given plan.
     *
     * The function iterates through each row and cell of the provided `plan`,
     * collecting unique names of rayons that are present. The result is an array
     * of distinct rayon names.
     *
     * @returns {Array<string>} An array containing unique rayon names.
     */
    const getListRayon = (): Array<string> => {
        let listRayons: Array<string> = []
        plan.map((row) => {
            row.filter(value1 => value1.type === PlanType.RAYON).map((cell) => {
                if (!listRayons.includes(cell.name)) {
                    listRayons.push(cell.name);
                }
            })
        })

        setColorRayons(listRayons.length)

        return listRayons;
    }

    /**
     * Function to download the current plan as a JSON file.
     * The function converts the `plan` object to a JSON string,
     * creates a Blob from the JSON string, and provides a download
     * link for the user to download the file named "plan.json".
     */
    const downloadPlanAsJSON = () => {
        const planJSON = JSON.stringify(plan, null, 2);
        const blob = new Blob([planJSON], {type: "application/json"});
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        const data = new Date();
        link.download = `plan-${props.name}-${data.toLocaleDateString()}-${data.toLocaleTimeString()}.json`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        setInfo({open: true, message: "Download Plan Success", type: "success"});

    };

    const affectProduitRayon = (product: ProductModel) => {

        if (!value) {
            setInfo({open: true, message: "Veuillez choisir un rayon", type: "error"});
            return
        }

        ProductService.addNewProductToRayonP({storeId: props.storeId, productId: product.id, name: value}).then(response => {
            console.log(response);
        })
    }

    const updateOpen = (newOpen: boolean) => {
        setInfo((prevState) => ({
            ...prevState,
            open: newOpen,
        }));
    };

    const getStyleRayon = (cell: Cell): CSSProperties => {
        if (cell.type === PlanType.RAYON) {
            const color = localStorage.getItem(cell.name);
            return {backgroundColor: color ? color : "#000000"}
        } else {
            return {}
        }
    }

    /**
     * Change le nombre de colonnes dans le plan
     */
    const handleChangeCols = () => {
        if (!plan[0])
            return;

        const diffCols = cols - plan[0].length;

        if (diffCols < 0) {
            // Remove cols
            const updatedPlan = plan.map((row) => row.slice(0, diffCols));
            setPlan(updatedPlan);
        } else {
            // Add cols
            const updatedPlan = plan.map((row) => [
                ...row,
                ...Array(diffCols).fill(EMPTY_CELL),
            ]);
            setPlan(updatedPlan);
        }
    };

    /**
     * Change le nombre de lignes dans le plan
     */
    const handleChangeRows = () => {
        const rowsDiff = rows - plan.length;

        if (rowsDiff < 0) {
            // Remove rows
            setPlan(plan.slice(0, rowsDiff));
        } else {
            // Add rows
            const newRows = Array(rowsDiff).fill(Array(cols).fill(EMPTY_CELL));
            setPlan([...plan, ...newRows]);
        }
    };

    useEffect(() => {
        handleChangeRows()
    }, [rows])

    useEffect(() => {
        handleChangeCols()
    }, [cols])

    const getTitleTooltip = (col: Cell) => {
        let tmp = col.type === PlanType.RAYON ? col.name : ""
        return tmp + (col.isBeacon ? " + beacon" : "")
    }

    const changeColors = () => {
        rayons.map(rayon => {
            localStorage.removeItem(rayon)
        })

        setColorRayons(rayons.length)
    }

    return (
        <div className={"single_shop"}>
            {info.open ? <div className={"info " + info.type}>
                <p>{info.message}</p>
                <div onClick={() => updateOpen(false)}>X</div>
            </div> : ""}
            <div className={"configPlan"}>
                <div>
                    <h3>Choix du stylo</h3>
                    <div>
                        {getListDrawType().map((planType, index) => (
                            <label key={index} className={"type"}>
                                <input
                                    type="radio"
                                    name={"checkbox"}
                                    value={planType}
                                    checked={currentDraw === planType}
                                    onChange={handleChangeRadio}
                                />
                                {planType}
                            </label>
                        ))}
                    </div>
                </div>
                <div>
                    <h3>Choix du rayon</h3>
                    <Autocomplete
                        value={value}
                        onChange={(_, newValue) => {
                            setCurrentDraw(PlanType.RAYON)
                            if (typeof newValue === 'string') {
                                if (newValue.includes("Add \"")) {
                                    setValue(newValue.split("\"")[1]);
                                    setRayons([...rayons, newValue.split("\"")[1]]);
                                    setColorRayons(rayons.length + 1);
                                } else {
                                    setValue(newValue);
                                }
                            } else {
                                setValue(null);
                            }
                        }}
                        filterOptions={(options, params) => {
                            const filtered = filter(options, params);

                            const {inputValue} = params;
                            // Suggest the creation of a new value if it doesn't exist
                            const isExisting = options.includes(inputValue);
                            if (inputValue !== '' && !isExisting) {
                                filtered.push(`Add "${inputValue}"`);
                            }

                            return filtered;
                        }}
                        selectOnFocus
                        clearOnBlur
                        handleHomeEndKeys
                        id="free-solo-with-text-demo"
                        options={rayons}
                        getOptionLabel={(option) => {
                            return option;
                        }}
                        renderOption={(props, option) => {
                            const {key, ...optionProps} = props;
                            return (
                                <li key={key} {...optionProps}>
                                    {option}
                                </li>
                            );
                        }}
                        sx={{width: 300}}
                        freeSolo
                        renderInput={(params) => (
                            <TextField {...params} label="Free solo with text demo"/>
                        )}
                    />
                </div>
                <div>
                    <h3>Ajout d'un produit</h3>
                    <Product type={"get"} onSubmit={affectProduitRayon} storeId={props.storeId}/>
                </div>
                <div>
                    <h3>Configuration de la grille</h3>
                    <TextField
                        id="outlined-controlled"
                        label="Nombres de rows"
                        value={rows}
                        type={"number"}
                        onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
                            setRows(parseInt(event.target.value));
                        }}
                    />
                    <br/>
                    <TextField
                        id="outlined-controlled"
                        label="Nombre de cols"
                        type={"number"}
                        value={cols}
                        onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
                            setCols(parseInt(event.target.value));
                        }}
                    />
                </div>
                <div>
                    <h3>Couleurs des rayons</h3>
                    <button className={"customButton"} onClick={changeColors}>Changer les couleurs</button>
                </div>
                <div>
                    <h3>Téléchargement du plan</h3>
                    <button className={"customButton"} onClick={downloadPlanAsJSON}>Download Plan as JSON</button>
                </div>
            </div>

            <table className={"plan"}>
                <tbody>
                {plan.map((row: Array<Cell>, rowIndex: any) => {
                    return (
                        <tr key={rowIndex}>
                            {row.map((col: Cell, colIndex) => (
                                <Tooltip title={getTitleTooltip(col)} key={colIndex}
                                         placement={"top"}>
                                    <td onClick={() => props.isEdit ? toggleCell(rowIndex, colIndex) : ""}
                                        className={getCellClass(rowIndex, colIndex)} style={getStyleRayon(col)}></td>
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

const SingleShop: React.FC = () => {

    const {id} = useParams<{ id: string }>();

    const [shop, setShop] = useState<ShopModel | null>(null);

    const [isEdit, setEdit] = useState(true);

    useEffect(() => {
        ShopService.getPlanById(id).then((data: ShopModel) => setShop(data))
    }, []);

    const updatePlan = (plan: Array<Array<Cell>> | null = null) => {
        if (!shop)
            return;

        if (plan)
            setShop({...shop, layout: plan});

        ShopService.updatePlan(shop?.id, shop).then()
    }

    useEffect(() => {
        if (shop)
            updatePlan()
    }, [shop]);

    const navigate = useNavigate();

    const removeShop = (id: number) => {
        ShopService.removePlan(id).then(() => navigate(`/shop`));
    }

    return (!shop ? <div>Loading...</div> :
        <div>
            <div className={"topContent"}>
                <div>
                    <h2>Id du Shop</h2>
                    <h3>{shop.id}</h3>
                </div>
                <div>
                    <h2>Nom</h2>
                    <TextField
                        id="outlined-controlled"
                        label="Nombres de rows"
                        value={shop.name}
                        type={"text"}
                        onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
                            setShop({...shop, name: event.target.value});
                        }}
                    />
                </div>
                <div>
                    <h2>Adresse</h2>
                    <TextField
                        id="outlined-controlled"
                        label="Nombres de rows"
                        value={shop.adresse}
                        type={"text"}
                        onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
                            setShop({...shop, adresse: event.target.value});
                        }}
                    />
                </div>
                <div>
                    <h2>Ville</h2>
                    <TextField
                        id="outlined-controlled"
                        label="Nombres de rows"
                        value={shop.ville}
                        type={"text"}
                        onChange={(event: React.ChangeEvent<HTMLInputElement>) => {
                            setShop({...shop, ville: event.target.value});
                        }}
                    />
                </div>
                <div>
                    <h2>Suppression</h2>
                    <Button color={"error"} onClick={() => removeShop(shop?.id)} variant="outlined" startIcon={<DeleteIcon />}>
                        Delete
                    </Button>
                </div>
            </div>
            <Plan name={shop.name} storeId={shop.id} onFinish={updatePlan} plan={shop.layout} isEdit={isEdit}/>
        </div>
    );
};

export default SingleShop;