import React from 'react'
import { Container, Grid, Card, CardContent, Typography, Button } from '@mui/material'

const Pricing = () => {
  return (
    <>
      <div className="bg-gray-200">
      <h1 className="text-black text-6xl font-semibold pl-9 pt-14 flex justify-center">Pricing</h1>
      <Container style={{padding: '40px'}}>
               <Grid container spacing={3} justifyContent="center">
                   <Grid item xs={12} sm={4}>

                    {/* Old content  */}
                       {/* <Card sx={{ height: '400px', width: '300px' }}>
                           <CardContent>
                               <Typography variant="h5">Free Plan</Typography>
                               <Typography variant="h4">$0</Typography>
                               <Typography>/ month</Typography>
                               <Button variant="contained"  sx={{ backgroundColor: 'black', color: 'white', marginTop: '20px' }}>
                                   Learn more
                               </Button>
                           </CardContent>
                       </Card> */}



                        <Card sx={{ height: '400px', width: '300px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px' }}>
                            <div>
                                <Typography variant="h5" sx={{ marginBottom: '10px' }}>Free Plan</Typography>
                                <Typography variant="h4" sx={{ marginBottom: '5px' }}>$0</Typography>
                                <Typography>/ month</Typography>
                            </div>
                            <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: 'auto', alignSelf: 'center' }}>
                                Learn more
                            </Button>
                        </Card>
                   </Grid>
                   <Grid item xs={12} sm={4}>
                       <Card sx={{ height: '400px', width: '300px', marginLeft: '38px' , display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px' }}>
                            <div>
                               <Typography variant="h5" sx={{ marginBottom: '10px' }}>Premium</Typography>
                               <Typography variant="h4" sx={{ marginBottom: '5px' }}>$50 </Typography>
                              <Typography>/ month</Typography>
                            </div>  
                               <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white',  marginTop: 'auto', alignSelf: 'center' }}>
                                   Learn more
                               </Button>
                       </Card>
                   </Grid>
                   <Grid item xs={12} sm={4}>
                       <Card sx={{ height: '400px', width: '300px', marginLeft: '60px' , display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '20px'  }}>
                            <div>
                               <Typography variant="h5" sx={{ marginBottom: '10px' }}>Enterprise</Typography>
                               <Typography variant="h4" sx={{ marginBottom: '5px' }}>$150</Typography>
                               <Typography>/ month</Typography>
                            </div>   
                               <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: 'auto', alignSelf: 'center' }}>
                                   Learn more
                               </Button>
                       </Card>
                   </Grid>
               </Grid>
               <div style={{ textAlign: 'center', marginTop: '40px' }}>
                   <Typography variant="h6">Love what you see?</Typography>
                   <Typography>Drop us a message and we’ll get back to you in no time!</Typography>
                   <Button variant="contained" sx={{ backgroundColor: 'black', color: 'white', marginTop: '20px' }}>
                       Get started
                   </Button>
               </div>
           </Container>
    </div> 

    </>
  )
}

export default Pricing
