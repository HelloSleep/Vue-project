<template>
  <div class="container" v-cloak>
    <Header :title="`물품 목록 [${this.region_cd}]`" @change-mode="changeMode" :isFormShown="isFormShown" />
    <div v-show="isFormShown">
      <ItemForm @add-item="addItem" />
    </div>
    <div id="items" v-show="!isFormShown">
      <Items :items="items" @edit-item="editItem" @delete-item='deleteItem' />
    </div>
    <div id="footer" v-show="!isFormShown" style="margin-top: 30px;">
      <div v-if="areItemsLoaded">
        <button class="btn" style="display: block; background-color: orange; margin: auto;" v-on:click="loadItems">REFRESH</button>
      </div>
      <div v-else>
        <img src="./assets/loading.gif" alt="Loading..." style="display: block; margin: auto; width: 30%; height: 30%;">
      </div>
    </div>
  </div>
</template>

<script>
import Header from './components/Header'
import Items from './components/Items'
import ItemForm from './components/ItemForm'

export default {
  name: 'App',
  components: {
    Header,
    Items,
    ItemForm
  },
  data() {
    return {
      region_cd: '',
      items: [],
      isFormShown: false,
      areItemsLoaded: false,
      startFrom: 0,
      endAt: 0,
      rowSize: 10
    }
  },
  methods: {
    changeMode() {
      this.isFormShown = !this.isFormShown
    },

    async fetchData(url_path, options) {
      const res = await fetch([process.env.VUE_APP_API_URL, url_path].join(''), options)
      const response = await res.json()
      if (!response.ok){
        console.log(`[${url_path}] 데이터 불러오기 실패...\n${response.message}\n`)
      }
      return response.data || null
    },

    async fetchResponse(url_path, options) {
      const res = await fetch([process.env.VUE_APP_API_URL, url_path].join(''), options)
      const response = await res.json()
      return response
    },

    async loadItems() {
      this.areItemsLoaded = false
      this.items = await this.fetchData(`items/${this.region_cd}`, {
        method: 'GET',
        mode: 'cors',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      })
      this.areItemsLoaded = true
    },

    async addItem(newItem) {
      newItem.region_cd = this.region_cd

      const response = await this.fetchResponse(`items/${this.region_cd}`, {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(newItem)
      })
      if (!response.ok) {
        alert("품목 추가 실패...\n", response.message)
      } else {
        this.changeMode()
        await this.loadItems()
      }
    },

    editItem(item) {
      console.log("Editing item >> ", item)
      // 입력 창으로 보내기
    },

    async deleteItem(item_cd) {
      console.log("Deleting item >> ", item_cd)

      // 성공 시 화면에서 삭제
      if (confirm(`물품번호 [${item_cd}] 을(를) 삭제할까요?`)) {
        const response = await this.fetchResponse(`items/${this.region_cd}`, {
          method: 'DELETE',
          mode: 'cors',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({item_cd: item_cd})
        })
        if (!response.ok) {
          alert("품목 삭제 실패...\n", response.message)
        } else {
          this.items = this.items.filter((item, index, array) => {
            return item.item_cd !== item_cd
          })
        }
      }
    }
  },
  async created() {
    // 지역 정보 불러오기
    this.region_cd = await this.fetchData(`region`, {
      method: 'GET',
      mode: 'cors',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    // 아이템 불러오기
    await this.loadItems()
  }
}
</script>

<style>
/* @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400&display=swap'); */
/* devanagari */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 300;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLDz8Z11lFc-K.woff2) format('woff2');
  unicode-range: U+0900-097F, U+1CD0-1CF6, U+1CF8-1CF9, U+200C-200D, U+20A8, U+20B9, U+25CC, U+A830-A839, U+A8E0-A8FB;
}

/* latin-ext */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 300;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLDz8Z1JlFc-K.woff2) format('woff2');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}

/* latin */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 300;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLDz8Z1xlFQ.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}

/* devanagari */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiEyp8kv8JHgFVrJJbecmNE.woff2) format('woff2');
  unicode-range: U+0900-097F, U+1CD0-1CF6, U+1CF8-1CF9, U+200C-200D, U+20A8, U+20B9, U+25CC, U+A830-A839, U+A8E0-A8FB;
}

/* latin-ext */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiEyp8kv8JHgFVrJJnecmNE.woff2) format('woff2');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}

/* latin */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/poppins/v20/pxiEyp8kv8JHgFVrJJfecg.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Poppins', sans-serif;
}

[v-cloak] {
  display: none;
}

.container {
  min-width: 500px;
  max-width: 1000px;
  margin: 30px auto;
  overflow: auto;
  min-height: 500px;
  border: 2px solid steelblue;
  padding: 30px;
  border-radius: 5px;
}

.btn {
  display: inline-block;
  background: #000;
  color: #fff;
  border: none;
  padding: 10px 12px;
  margin: 5px;
  border-radius: 5px;
  cursor: pointer;
  text-decoration: none;
  font-size: 15px;
  font-family: inherit;
}

.btn:focus {
  outline: none;
}

.btn:active {
  transform: scale(0.98);
}

.btn-block {
  display: block;
  width: 100%;
}

/*
#app {
  width: 400px;
  height: 100vh;
  margin: auto;
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
*/
</style>
