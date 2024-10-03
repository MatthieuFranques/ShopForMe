import React, {useState} from 'react';
import './form.scss'
import { useNavigate } from "react-router-dom";
import {Button, FormControl, InputLabel, MenuItem, Select, TextField} from "@mui/material";
import {ShopModel} from '../../models/Shop.model'

interface ShopFormCreateProps {
    onSubmit: (shop: ShopModel) => void;
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
    const [formData, setFormData] = useState<ShopModel>({
        name: '',
        address: '',
        city: '',
    });

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
    };

    return (
        <form onSubmit={handleSubmit}>
            <div>
                <TextField
                    fullWidth
                    id="outlined-controlled"
                    label="Name"
                    value={formData.name}
                    onChange={handleChange}
                />
            </div>
            <div>
                <TextField
                    id="outlined-controlled"
                    fullWidth
                    label="Address"
                    value={formData.address}
                    onChange={handleChange}
                />
            </div>
            <div>
                <TextField
                    id="outlined-controlled"
                    label="City"
                    fullWidth
                    value={formData.city}
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
    const [shop, setShop] = useState<string>("shop1");

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
                    labelId="demo-simple-select-label"
                    id="demo-simple-select"
                    value={shop}
                    label="Select Shop:"
                    onChange={handleChange}
                >
                    <MenuItem value={"shop1"}>Shop 1</MenuItem>
                    <MenuItem value={"shop2"}>Shop 2</MenuItem>
                    <MenuItem value={"shop3"}>Shop 3</MenuItem>
                </Select>
            </FormControl>
            <Button variant="contained" type={"submit"}>Visit Shop</Button>
        </form>
    );
};

const Shop: React.FC = () => {

    const navigate = useNavigate();

    const handleCreateShop = (shop: ShopModel) => {
        console.log('Shop created: ', shop);
    };

    const handleListConsultShop = (shop: string) => {
        console.log('Shop list: ', shop);
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