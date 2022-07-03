<template>
    <div :class="[item.is_banned == 1 ? 'banned' : '', 'item']">
        <h3 @dblclick="$emit('edit-item', item)">
            {{ item.item_nm }} [{{ item.item_cd }}]
            <i class="fas fa-times" @click="$emit('delete-item', item.item_cd)"></i>
        </h3>
        <p>재고 수량: {{ item.quantity }} 개</p>
    </div>

</template>

<script>
export default {
    name: 'Item',
    props: {
        item: Object
    },
    emits: ['edit-item', 'delete-item']
}
</script>

<style scoped>
.fas {
    color: red;
    cursor: pointer;
}

.item {
    background: #f4f4f4;
    margin: 5px;
    padding: 10px 20px;
}

.item.banned {
    border-left: 5px solid red;
}

.item h3 {
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: pointer;
}
</style>