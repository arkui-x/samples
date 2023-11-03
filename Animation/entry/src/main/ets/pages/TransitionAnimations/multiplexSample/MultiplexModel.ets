export class MultiplexModel {
  private id: string;
  private img: Resource;

  constructor(id: string, img: Resource) {
    this.id = id;
    this.img = img;
  }

  getId():string {
    return this.id;
  }

  getImg():Resource {
    return this.img;
  }
}