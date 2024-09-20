import React, {useState} from 'react';
import './form.css'
import { useNavigate } from "react-router-dom";

interface ShopFormCreateProps {
    onSubmit: (shop: ShopFormData) => void;
}

interface ShopFormListProps {
    onSubmit: (shop: string) => void;
}

interface ShopFormData {
    name: string;
    address: string;
    city: string;
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
    const [formData, setFormData] = useState<ShopFormData>({
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
                <label htmlFor="name">Name:</label>
                <input
                    type="text"
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                />
            </div>
            <div>
                <label htmlFor="address">Address:</label>
                <input
                    type="text"
                    id="address"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                    required
                />
            </div>
            <div>
                <label htmlFor="city">City:</label>
                <input
                    type="text"
                    id="city"
                    name="city"
                    value={formData.city}
                    onChange={handleChange}
                    required
                />
            </div>
            <button type="submit">Create Shop</button>
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

    const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setShop(e.target.value);
    };

    const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        onSubmit(shop);
    };

    return (
        <form onSubmit={handleSubmit}>
            <label htmlFor="shopList">Select Shop:</label>
            <select id="shopList" name="shopList" value={shop} onChange={handleChange} required>
                <option value="shop1">Shop 1</option>
                <option value="shop2">Shop 2</option>
                <option value="shop3">Shop 3</option>
            </select>
            <button type="submit">Create Shop</button>
        </form>
    );
};

const Shop: React.FC = () => {

    const navigate = useNavigate();

    const handleCreateShop = (shop: ShopFormData) => {
        console.log('Shop created: ', shop);
    };

    const handleListConsultShop = (shop: string) => {
        console.log('Shop list: ', shop);
        navigate("/shop/" + shop);
    }

    return (
        <div>
            <h1>Create a new Shop</h1>
            <ShopFormCreate onSubmit={handleCreateShop}/>

            <h1>Consult a shop</h1>
            <ShopFormList onSubmit={handleListConsultShop}/>
        </div>
    );
};

export default Shop;