from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Product(BaseModel):
    name: str
    price: float
    stock: int

@app.get("/")
async def root():
    return "CHAAAAMA"


@app.get("/products")
async def get_products():
    return products

@app.get("/products/{product_id}")
async def get_product(product_id: int):
    product = products[product_id-1]
    return product

@app.post("/products")
async def create_product(product: Product):
    products.append(product.dict())
    return products[-1]

@app.put("/products/{product_id}")
async def update_product(product_id: int, product: Product):
    products[product_id-1] = product.dict()
    return products[product_id-1]

@app.delete("/products/{product_id}")
async def delete_product(product_id: int):
    products.pop(product_id-1)
    return {"message": "Product deleted!"}

products = [
    {
        "name": "Phone",
        "price": 800,
        "stock": 1
    },
    {
        "name": "PC",
        "price": 2000,
        "stock": 2
    },
    {
        "name": "Car",
        "price": 20000,
        "stock": 3
    }
]
