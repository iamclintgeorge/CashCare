import Header from "./Components/Header";
import Herosec from "./Sections/Herosec";
import Whycashcare from "./Sections/Whycashcare";
import Pricing from "./Sections/Pricing";

export default function Home() {
  return (
    <main>
      <Header />
      <Herosec />
      <Whycashcare />
      <Pricing />
    </main>
  );
}
