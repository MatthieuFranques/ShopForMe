import React, {useEffect, useState} from "react";
import {Autocomplete, Button, createFilterOptions, TextField} from "@mui/material";
import {ProductModel} from "../../models/Product.model";
import {api, onError} from "../../utils/utils";

interface ProductFormCreateProps {
    onSubmit: (shop: any) => void;
    storeId: number;
}

interface ProductFormProps {
    type: 'create' | 'update' | 'delete' | 'get';
    onSubmit: (data: any) => void;
    storeId: number;
}

export const Product: React.FC<ProductFormProps> = ({type, onSubmit, storeId}) => {


    switch (type) {
        case "get":
            return <Get onSubmit={onSubmit} storeId={storeId}/>
        case "create":
            return <Create onSubmit={onSubmit} storeId={storeId}/>
        default:
            return <></>
    }
}

const Create: React.FC<ProductFormCreateProps> = ({onSubmit}) => {

    const [formData, setFormData] = useState<ProductModel>({
        name: '',
        category: '',
        rayon: '',
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

    return (<form onSubmit={handleSubmit}>
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
                value={formData.category}
                onChange={handleChange}
            />
        </div>
        <div>
            <TextField
                id="outlined-controlled"
                label="City"
                fullWidth
                value={formData.rayon}
                onChange={handleChange}
            />
        </div>
        <Button variant="contained" type={"submit"}>Create Produit</Button>
    </form>)
}

const Get: React.FC<ProductFormCreateProps> = ({onSubmit, storeId}) => {

    const [produits, setProducts] = useState<Array<ProductModel>>([])

    useEffect(() => {
        api("GET", `product/getFree/${storeId}`, undefined, onGetProduitSuccess, onError)
    }, [])

    const onGetProduitSuccess = (data: ProductModel[]) => {
        setProducts(data.sort((a, b) => a.name.localeCompare(b.name)))
    }

    const [value, setValue] = React.useState<ProductModel  | null>(null);

    const filter = createFilterOptions<ProductModel>();

    return (
        <div>
            <Autocomplete
                value={value}
                onChange={(event, newValue) => {
                    if (typeof newValue === 'string') {
                        setValue({
                            name: newValue,
                            category: "0",
                            rayon: "0"
                        });
                    } else if (newValue) {
                        if (newValue.name.includes("Add \"")) {
                            newValue.name = newValue.name.split("\"")[1]
                        }
                        setValue(newValue);
                    } else {
                        setValue(null);
                    }
                }}
                filterOptions={(options, params) => {
                    const filtered = filter(options, params);

                    const { inputValue } = params;
                    // Vérifier si l'entrée existe déjà
                    const isExisting = options.some((option) => inputValue === option.name);
                    if (inputValue !== '' && !isExisting) {
                        filtered.push({
                            name: `Add "${inputValue}"`,
                            category: "0",
                            rayon: "0",
                        });
                    }

                    return filtered;
                }}
                selectOnFocus
                clearOnBlur
                handleHomeEndKeys
                id="free-solo-with-text-demo"
                options={produits}
                getOptionLabel={(option) => {
                    if (typeof option === 'string') {
                        return option;
                    }
                    return option.name;
                }}
                renderOption={(props, option) => {
                    const {key, ...optionProps} = props;
                    return (
                        <li key={key} {...optionProps}>
                            {option.name} - {option.category}
                        </li>
                    );
                }}
                sx={{width: 300}}
                freeSolo
                renderInput={(params) => (
                    <TextField {...params} label="List product..."/>
                )}
            />
            <button disabled={!value} onClick={() => onSubmit(value)}>Ajouter le produits au rayon</button>
        </div>
    )
}