import React, {useEffect, useState} from 'react';
import './form.scss'
import {useNavigate} from "react-router-dom";
import {Button, FormControl, InputLabel, MenuItem, Select, TextField} from "@mui/material";
import {ShopModel, ShopModelCreate} from '../../models/Shop.model'
import {ShopService} from "../../services/shop.service";


interface ShopFormCreateProps {
    onSubmit: (shop: ShopModelCreate) => void;
}

interface ShopFormListProps {
    onSubmit: (shop: string) => void;
}


/**
 * `ShopFormCreate` is a React functional component that renders a form
 * for creating a new shop. The form includes fields for the shop's
 * name, address, and city. When the form is submitted, the form data
 * is passed to the supplied `onSubmit` callback function.
 *
 * @type {React.FC<ShopFormCreateProps>}
 * @param {Object} props - The properties object.
 * @param {function} props.onSubmit - Callback function that is called
 * when the form is submitted, passing the form data as a parameter.
 */
const ShopFormCreate: React.FC<ShopFormCreateProps> = ({onSubmit}) => {
    const [formData, setFormData] = useState<ShopModelCreate>({
        name: '',
        adresse: '',
        ville: '',
    });

    const navigate = useNavigate();

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const {name, value} = e.target;
        setFormData(prevFormData => ({
            ...prevFormData,
            [name]: value,
        }));
    };

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        onSubmit(formData);
        ShopService.createShop(formData).then((data: ShopModel) => navigate(`/shop/${data.id}`))
    };

    return (
        <form onSubmit={handleSubmit}>
            <div>
                <TextField
                    fullWidth
                    id="name"
                    name="name"
                    label="Name"
                    value={formData.name}
                    onChange={handleChange}
                />
            </div>
            <div>
                <TextField
                    id="outlined-controlled"
                    fullWidth
                    name="adresse"
                    label="Address"
                    value={formData.adresse}
                    onChange={handleChange}
                />
            </div>
            <div>
                <TextField
                    id="outlined-controlled"
                    label="City"
                    fullWidth
                    value={formData.ville}
                    name="ville"
                    onChange={handleChange}
                />
            </div>
            <Button variant="contained" type={"submit"}>Create Shop</Button>
        </form>
    );
};

/**
 * A React functional component that renders a form allowing users to select a shop from a dropdown list and submit their selection.
 *
 * @component
 * @param {Object} props The component props.
 * @param {Function} props.onSubmit Callback function to handle form submission. It takes the selected shop as an argument.
 * @returns {JSX.Element} A JSX element representing the shop selection form with a dropdown and submit button.
 */
const ShopFormList: React.FC<ShopFormListProps> = ({onSubmit}) => {

    const [allShops, setAllShops] = useState<ShopModel[]>([]);

    const [shop, setShop] = useState<string>("");

    useEffect(() => {
        ShopService.getAllShop().then((data: ShopModel[]) => {
            setAllShops(data);
            if (data[0])
                setShop(`${data[0].id}`)
        })
    }, [])

    const handleChange = (e: any) => {
        setShop(e.target.value);
    };

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        onSubmit(shop);
    };

    return (

        <form onSubmit={handleSubmit}>
            <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Select Shop:</InputLabel>
                <Select
                    variant={"filled"}
                    labelId="demo-simple-select-label"
                    id="demo-simple-select"
                    value={shop}
                    label="Select Shop:"
                    onChange={handleChange}
                >
                    {allShops.map((shop: ShopModel) => (
                        <MenuItem value={shop.id} key={shop.id}>{shop.name}</MenuItem>
                    ))}
                </Select>
            </FormControl>
            <Button variant="contained" type={"submit"}>Visit Shop</Button>
        </form>
    );
};

const Shop: React.FC = () => {

    const navigate = useNavigate();

    const handleCreateShop = (shop: ShopModelCreate) => {
        console.log('Shop created: ', shop);
    };

    const handleListConsultShop = (shop: string) => {
        navigate("/shop/" + shop);
    }

    return (
        <div className={"shop_container"}>
            <div>
                <h1>Create a new Shop</h1>
                <ShopFormCreate onSubmit={handleCreateShop}/>
            </div>

            <div>
                <h1>Consult a Shop</h1>
                <ShopFormList onSubmit={handleListConsultShop}/>
            </div>
        </div>
    );
};

export default Shop;